import { Component, signal, OnInit, OnDestroy } from '@angular/core';

interface StatItem {
  label: string;
  value: string | number;
  delta: string;
  trend: 'up' | 'down' | 'neutral';
  color: string;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  template: `
    <div class="animate-fade-in">
      <!-- Live Stats Grid -->
      <div class="grid-stats">
        @for (stat of stats(); track stat.label) {
          <div class="card-stat glass" [style.border-top-color]="stat.color" style="border-top-width: 4px;">
            <div class="stat-label">{{ stat.label }}</div>
            <div class="stat-value" [style.color]="stat.color">{{ stat.value }}</div>
            <div class="stat-delta">
              <span [class.trend-up]="stat.trend === 'up'" [class.trend-down]="stat.trend === 'down'">
                {{ stat.delta }}
              </span>
            </div>
          </div>
        }
      </div>

      <!-- Radial Gauges & Architecture -->
      <div class="grid-metrics">
        <div class="card-metric glass">
          <div class="metric-title">
            <span>Live System Performance</span>
            <span style="font-size: 0.8rem; font-weight: normal; color: var(--text-muted);">Auto-updating</span>
          </div>
          
          <div class="radial-container">
            <!-- CPU gauge -->
            <div class="radial-progress">
              <svg>
                <circle class="radial-bg" cx="60" cy="60" r="50"></circle>
                <circle class="radial-value" cx="60" cy="60" r="50"
                  [attr.stroke-dasharray]="314.16"
                  [attr.stroke-dashoffset]="314.16 - (314.16 * cpuUsage() / 100)"></circle>
              </svg>
              <div class="radial-text">
                <span class="radial-num">{{ cpuUsage() }}%</span>
                <span class="radial-label">CPU</span>
              </div>
            </div>

            <!-- Memory gauge -->
            <div class="radial-progress">
              <svg>
                <circle class="radial-bg" cx="60" cy="60" r="50"></circle>
                <circle class="radial-value" cx="60" cy="60" r="50"
                  stroke="var(--secondary)"
                  [attr.stroke-dasharray]="314.16"
                  [attr.stroke-dashoffset]="314.16 - (314.16 * memoryUsage() / 100)"></circle>
              </svg>
              <div class="radial-text">
                <span class="radial-num">{{ memoryUsage() }}%</span>
                <span class="radial-label">RAM</span>
              </div>
            </div>
          </div>

          <div style="margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--border-color); font-size: 0.85rem; display: flex; justify-content: space-between;">
            <span style="color: var(--text-muted)">Active Sessions:</span>
            <strong>{{ activeSessions() }} live sessions</strong>
          </div>
          <div style="margin-top: 8px; font-size: 0.85rem; display: flex; justify-content: space-between;">
            <span style="color: var(--text-muted)">JVM Uptime:</span>
            <strong>{{ formatUptime(uptimeSeconds()) }}</strong>
          </div>
        </div>

        <!-- Architecture & Flow Diagram -->
        <div class="card-metric glass">
          <div class="metric-title">Deployment Flow (Offline Mode)</div>
          <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 16px;">
            How the Java Servlet delivers this page without internet dependencies:
          </p>
          
          <div style="display: flex; flex-direction: column; gap: 12px; font-size: 0.85rem;">
            <div style="display: flex; align-items: center; gap: 12px; padding: 10px; background: rgba(255, 255, 255, 0.02); border-radius: var(--border-radius); border: 1px solid var(--border-color);">
              <div style="background: var(--primary); width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.75rem; color: var(--text-inverse);">1</div>
              <div>
                <strong>Angular Build:</strong> Outputs local JS, CSS, and HTML with relative links (<code>base href="./"</code>).
              </div>
            </div>
            <div style="display: flex; align-items: center; gap: 12px; padding: 10px; background: rgba(255, 255, 255, 0.02); border-radius: var(--border-radius); border: 1px solid var(--border-color);">
              <div style="background: var(--secondary); width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.75rem; color: var(--text-inverse);">2</div>
              <div>
                <strong>Servlet Deployment:</strong> Files are copied into the <code>/webapp/preview/</code> folder in the WAR.
              </div>
            </div>
            <div style="display: flex; align-items: center; gap: 12px; padding: 10px; background: rgba(255, 255, 255, 0.02); border-radius: var(--border-radius); border: 1px solid var(--border-color);">
              <div style="background: var(--success); width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.75rem; color: var(--text-inverse);">3</div>
              <div>
                <strong>Browser Request:</strong> Served by the local servlet container directly with absolute MIME type fidelity.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class DashboardComponent implements OnInit, OnDestroy {
  // Live Stats from Servlet Backend
  activeUsers = signal<number>(0);
  usersCreated = signal<number>(0);
  activeSessions = signal<number>(0);
  jvmUptimeMs = signal<number>(0);
  uptimeSeconds = signal<number>(0);

  // Simulated metrics
  cpuUsage = signal<number>(24);
  memoryUsage = signal<number>(45);

  stats = signal<StatItem[]>([
    { label: 'Active Sessions', value: '...', delta: 'Loading...', trend: 'neutral', color: 'var(--primary)' },
    { label: 'Users Created', value: '...', delta: 'Loading...', trend: 'neutral', color: 'var(--success)' },
    { label: 'Active Users (Memory)', value: '...', delta: 'Loading...', trend: 'neutral', color: 'var(--secondary)' },
    { label: 'JVM Uptime', value: '...', delta: 'Loading...', trend: 'neutral', color: 'var(--warning)' }
  ]);

  private statsInterval: any;
  private metricsInterval: any;

  ngOnInit() {
    this.fetchStats();
    this.statsInterval = setInterval(() => this.fetchStats(), 3000);
    this.metricsInterval = setInterval(() => {
      this.cpuUsage.set(Math.floor(15 + Math.random() * 35));
      this.memoryUsage.set(Math.floor(40 + Math.random() * 20));
    }, 4000);
  }

  async fetchStats() {
    try {
      const response = await fetch('../api/stats');
      if (!response.ok) throw new Error();
      const data = await response.json();

      this.activeUsers.set(data.activeUsers ?? 0);
      this.usersCreated.set(data.usersCreated ?? 0);
      this.activeSessions.set(data.activeSessions ?? 0);
      this.jvmUptimeMs.set(data.jvmUptimeMs ?? 0);
      this.uptimeSeconds.set(Math.floor((data.jvmUptimeMs ?? 0) / 1000));

      this.stats.set([
        { label: 'Active Sessions', value: this.activeSessions(), delta: 'Live HTTP sessions', trend: 'up', color: 'var(--primary)' },
        { label: 'Users Created', value: this.usersCreated(), delta: 'Total since startup', trend: this.usersCreated() > 0 ? 'up' : 'neutral', color: 'var(--success)' },
        { label: 'Active Users (Memory)', value: this.activeUsers(), delta: 'In-memory mock store', trend: 'neutral', color: 'var(--secondary)' },
        { label: 'JVM Uptime', value: this.formatUptime(this.uptimeSeconds()), delta: 'Tomcat/JVM running time', trend: 'up', color: 'var(--warning)' }
      ]);
    } catch {
      this.stats.set([
        { label: 'Active Sessions', value: '1 (Offline)', delta: 'Client simulation', trend: 'neutral', color: 'var(--primary)' },
        { label: 'Users Created', value: '12 (Offline)', delta: 'Client simulation', trend: 'neutral', color: 'var(--success)' },
        { label: 'Active Users (Memory)', value: '3 (Offline)', delta: 'Client simulation', trend: 'neutral', color: 'var(--secondary)' },
        { label: 'JVM Uptime', value: 'N/A', delta: 'No backend API detected', trend: 'down', color: 'var(--warning)' }
      ]);
    }
  }

  formatUptime(sec: number): string {
    if (sec <= 0) return '00:00:00';
    const hrs = Math.floor(sec / 3600);
    const mins = Math.floor((sec % 3600) / 60);
    const secs = sec % 60;
    return `${hrs.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  ngOnDestroy() {
    if (this.statsInterval) clearInterval(this.statsInterval);
    if (this.metricsInterval) clearInterval(this.metricsInterval);
  }
}
