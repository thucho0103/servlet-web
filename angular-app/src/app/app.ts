import { Component, signal, effect, OnInit, ViewEncapsulation, inject } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive, Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.html',
  styleUrl: './app.css',
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  encapsulation: ViewEncapsulation.None,
  standalone: true
})
export class App implements OnInit {
  private router = inject(Router);

  // Standalone Mode State
  isStandalone = signal<boolean>(false);

  // Customizer State
  theme = signal<'dark' | 'light'>('dark');
  primaryColor = signal<string>('#6366f1');
  borderRadius = signal<number>(12);

  // Live Stats (Header)
  appName = signal<string>('Loading...');
  environment = signal<string>('Loading...');
  serverInfo = signal<string>('Loading...');
  serverTime = signal<string>('Loading...');

  toastMessage = signal<string | null>(null);

  constructor() {
    effect(() => {
      if (typeof document !== 'undefined') {
        const currentTheme = this.theme();
        document.documentElement.setAttribute('data-theme', currentTheme);
        document.body.style.backgroundColor = currentTheme === 'dark' ? '#0b0f19' : '#f8fafc';
      }
    });

    effect(() => {
      if (typeof document !== 'undefined') {
        document.documentElement.style.setProperty('--primary', this.primaryColor());
        document.documentElement.style.setProperty('--primary-glow', `${this.primaryColor()}26`);
      }
    });

    effect(() => {
      if (typeof document !== 'undefined') {
        document.documentElement.style.setProperty('--border-radius', `${this.borderRadius()}px`);
      }
    });
  }

  ngOnInit() {
    if (typeof window !== 'undefined') {
      this.fetchBasicStats();

      // Check for standalone preview mode
      const params = new URLSearchParams(window.location.search);
      const mode = params.get('mode');
      const template = params.get('template');
      if (mode === 'standalone' && template) {
        this.isStandalone.set(true);
        // Wait a tick for router to boot, then navigate preserving all parameters
        setTimeout(() => {
          this.router.navigate([`/${template}`], { queryParamsHandling: 'preserve' });
        });
      }
    }
  }

  async fetchBasicStats() {
    try {
      const response = await fetch('../api/stats');
      if (response.ok) {
        const data = await response.json();
        this.appName.set(data.appName || 'servlet-web');
        this.environment.set(data.environment || 'development');
        this.serverInfo.set(data.serverInfo || 'Tomcat');
        this.serverTime.set(data.now || new Date().toISOString());
      }
    } catch {
      this.appName.set('servlet-web (Offline)');
      this.environment.set('offline');
      this.serverInfo.set('Local Browser');
      this.serverTime.set(new Date().toISOString());
    }
  }

  toggleTheme() {
    this.theme.update(t => t === 'dark' ? 'light' : 'dark');
    this.showToast(`Switched to ${this.theme().toUpperCase()} theme`);
  }

  setPrimaryColor(color: string) {
    this.primaryColor.set(color);
    this.showToast(`Updated primary accent color to ${color}`);
  }

  updateBorderRadius(event: Event) {
    const value = +(event.target as HTMLInputElement).value;
    this.borderRadius.set(value);
  }

  showToast(message: string) {
    this.toastMessage.set(message);
    setTimeout(() => {
      if (this.toastMessage() === message) this.toastMessage.set(null);
    }, 3000);
  }
}
