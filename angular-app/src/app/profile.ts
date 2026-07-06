import { Component, signal, OnInit } from '@angular/core';

@Component({
  selector: 'app-profile',
  standalone: true,
  template: `
    <div class="animate-fade-in glass" style="padding: 32px; display: flex; flex-direction: column; gap: 24px;">
      
      <!-- Profile Header Row -->
      <div style="display: flex; gap: 24px; align-items: center; border-bottom: 1px solid var(--border-color); padding-bottom: 24px; flex-wrap: wrap;">
        <!-- Mock Avatar -->
        <div style="width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--secondary)); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: bold; color: var(--text-inverse); box-shadow: 0 8px 24px var(--primary-glow);">
          {{ avatarInitials() }}
        </div>
        <div>
          <h2 style="font-size: 1.75rem; margin-bottom: 4px;">{{ profileName() }}</h2>
          <p style="color: var(--text-muted); font-size: 0.9rem; font-weight: 500;">
            {{ profileRole() }} &middot; <span class="status-badge stable">Administrator</span>
          </p>
          <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">
            Role: Local Admin &middot; Host IP: 127.0.0.1 (Offline Context)
          </p>
        </div>
      </div>

      <!-- Content Split Grid -->
      <div class="showcase-grid">
        
        <!-- Left: Bio & Skills -->
        <div class="glass" style="padding: 20px; background: rgba(255,255,255,0.01);">
          <h3 style="margin-bottom: 12px; font-size: 1.15rem;">Bio & Skillset</h3>
          <p style="font-size: 0.85rem; color: var(--text-muted); line-height: 1.5; margin-bottom: 16px;">
            Enthusiast developer specializing in containerized deployments, modern front-end interfaces, and high-performance offline architectures.
          </p>
          <h4 style="font-size: 0.95rem; margin-bottom: 8px;">Technological Focus:</h4>
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <span class="status-badge stable" style="background: var(--primary-glow); color: var(--text-main);">Java Servlet 6.0</span>
            <span class="status-badge stable" style="background: var(--primary-glow); color: var(--text-main);">Angular 19/21</span>
            <span class="status-badge stable" style="background: var(--primary-glow); color: var(--text-main);">Tomcat & WebOTX</span>
            <span class="status-badge stable" style="background: var(--primary-glow); color: var(--text-main);">TypeScript</span>
          </div>
        </div>

        <!-- Right: Config toggles -->
        <div class="glass" style="padding: 20px; background: rgba(255,255,255,0.01);">
          <h3 style="margin-bottom: 12px; font-size: 1.15rem;">Local User Preferences</h3>
          <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 16px;">Set runtime parameters for this preview session.</p>
          
          <div style="display: flex; flex-direction: column; gap: 12px;">
            <div style="display: flex; align-items: center; justify-content: space-between;">
              <span style="font-size: 0.85rem; font-weight: 500;">Email Alerts</span>
              <button class="status-badge" 
                [class.stable]="mailAlerts()"
                [style.background]="mailAlerts() ? 'var(--success)' : 'rgba(255,255,255,0.05)'"
                [style.color]="mailAlerts() ? 'var(--text-inverse)' : 'var(--text-muted)'"
                style="border: none; cursor: pointer;"
                (click)="togglePreference('mail')">
                {{ mailAlerts() ? 'Enabled' : 'Disabled' }}
              </button>
            </div>
            
            <div style="display: flex; align-items: center; justify-content: space-between;">
              <span style="font-size: 0.85rem; font-weight: 500;">Profile Visibility</span>
              <button class="status-badge"
                [class.stable]="profileVisible()"
                [style.background]="profileVisible() ? 'var(--primary)' : 'rgba(255,255,255,0.05)'"
                [style.color]="profileVisible() ? 'var(--text-inverse)' : 'var(--text-muted)'"
                style="border: none; cursor: pointer;"
                (click)="togglePreference('visibility')">
                {{ profileVisible() ? 'Public' : 'Private' }}
              </button>
            </div>
          </div>
        </div>

      </div>

    </div>

    <!-- Toast Notification -->
    @if (toastMessage()) {
      <div class="toast-msg">
        <span class="toast-dot"></span>
        <span>{{ toastMessage() }}</span>
      </div>
    }
  `
})
export class ProfileComponent implements OnInit {
  profileName = signal<string>('Thuc Duy');
  profileRole = signal<string>('Senior Java & Angular Engineer');
  avatarInitials = signal<string>('TD');

  mailAlerts = signal<boolean>(true);
  profileVisible = signal<boolean>(true);
  toastMessage = signal<string | null>(null);

  ngOnInit() {
    if (typeof window !== 'undefined') {
      // 1. Đọc dữ liệu từ localStorage trước
      const rawData = localStorage.getItem('preview_data');
      if (rawData) {
        try {
          const data = JSON.parse(rawData);
          if (data.title) {
            this.profileName.set(data.title);
            const initials = data.title.split(' ').map((w: string) => w[0]).join('').substring(0, 2).toUpperCase();
            if (initials) this.avatarInitials.set(initials);
          }
          if (data.desc) this.profileRole.set(data.desc);
          return;
        } catch (e) {}
      }

      // 2. Dự phòng: Đọc từ URL Query Parameters nếu localStorage trống
      const params = new URLSearchParams(window.location.search);
      const title = params.get('title');
      const desc = params.get('desc');
      if (title) {
        this.profileName.set(title);
        // Extract initials for the avatar (up to 2 characters)
        const initials = title.split(' ').map(w => w[0]).join('').substring(0, 2).toUpperCase();
        if (initials) this.avatarInitials.set(initials);
      }
      if (desc) this.profileRole.set(desc);
    }
  }

  togglePreference(type: 'mail' | 'visibility') {
    if (type === 'mail') {
      this.mailAlerts.update(v => !v);
      this.showToast(`Email Alerts: ${this.mailAlerts() ? 'ON' : 'OFF'}`);
    } else {
      this.profileVisible.update(v => !v);
      this.showToast(`Visibility set to: ${this.profileVisible() ? 'PUBLIC' : 'PRIVATE'}`);
    }
  }

  showToast(message: string) {
    this.toastMessage.set(message);
    setTimeout(() => {
      if (this.toastMessage() === message) this.toastMessage.set(null);
    }, 3000);
  }
}
