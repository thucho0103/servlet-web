import { Component, signal, OnInit } from '@angular/core';

@Component({
  selector: 'app-landing',
  standalone: true,
  template: `
    <div class="animate-fade-in glass" style="padding: 32px;">
      <!-- Hero Banner -->
      <div class="hero-section" style="text-align: center; padding: 40px 20px; border-bottom: 1px solid var(--border-color); margin-bottom: 32px;">
        <h2 style="font-size: 2.25rem; font-weight: 800; background: linear-gradient(135deg, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 12px;">
          {{ pageTitle() }}
        </h2>
        <p style="color: var(--text-muted); font-size: 1.1rem; max-width: 600px; margin: 0 auto 24px auto;">
          {{ pageDesc() }}
        </p>
        <button class="btn-glow" (click)="triggerAction('CTA Button clicked')">Get Started Today</button>
      </div>

      <!-- Feature Grid -->
      <h3 style="margin-bottom: 20px;">Platform Features</h3>
      <div class="showcase-grid" style="margin-bottom: 40px;">
        <div class="glass" style="padding: 24px; background: rgba(255, 255, 255, 0.01);">
          <div class="logo-icon" style="background: var(--primary); margin-bottom: 16px;">⚡</div>
          <h4 style="margin-bottom: 8px;">Ultra-fast Rendering</h4>
          <p style="font-size: 0.85rem; color: var(--text-muted); line-height: 1.5;">
            Compiled Ahead-of-Time (AOT). The browser executes all code client-side, giving page response times under 10ms.
          </p>
        </div>
        
        <div class="glass" style="padding: 24px; background: rgba(255, 255, 255, 0.01);">
          <div class="logo-icon" style="background: var(--secondary); margin-bottom: 16px;">🛡️</div>
          <h4 style="margin-bottom: 8px;">Isolated Security</h4>
          <p style="font-size: 0.85rem; color: var(--text-muted); line-height: 1.5;">
            Runs entirely inside your servlet container context without internet queries, keeping metadata and source secure.
          </p>
        </div>

        <div class="glass" style="padding: 24px; background: rgba(255, 255, 255, 0.01);">
          <div class="logo-icon" style="background: var(--accent); margin-bottom: 16px;">🎨</div>
          <h4 style="margin-bottom: 8px;">Dynamic Themes</h4>
          <p style="font-size: 0.85rem; color: var(--text-muted); line-height: 1.5;">
            Tweak branding parameters on-the-fly. The CSS custom properties compile instantly to refresh styles without reloading.
          </p>
        </div>
      </div>

      <!-- Contact Form Mockup -->
      <div class="glass" style="padding: 24px; max-width: 500px; margin: 0 auto; background: rgba(0, 0, 0, 0.15);">
        <h3 style="margin-bottom: 16px; text-align: center;">Inquire for Details</h3>
        
        @if (formSubmitted()) {
          <div class="glass-alert" style="margin-bottom: 16px;">
            <span>📩 Request recorded locally! (Offline Demo)</span>
          </div>
        }

        <div class="control-group">
          <label style="color: var(--text-main);">Full Name</label>
          <input type="text" placeholder="John Doe" class="range-slider" style="background: rgba(255, 255, 255, 0.05); height: 40px; padding: 0 12px; color: #fff; border: 1px solid var(--border-color); border-radius: var(--border-radius); width: 100%; box-shadow: none;">
        </div>
        <div class="control-group">
          <label style="color: var(--text-main);">Email Address</label>
          <input type="email" placeholder="john@company.local" class="range-slider" style="background: rgba(255, 255, 255, 0.05); height: 40px; padding: 0 12px; color: #fff; border: 1px solid var(--border-color); border-radius: var(--border-radius); width: 100%; box-shadow: none;">
        </div>
        <button class="btn-glow" style="width: 100%; animation: none; margin-top: 12px;" (click)="submitForm()">Submit Inquiry</button>
      </div>
    </div>

    <!-- Local Toast -->
    @if (toastMessage()) {
      <div class="toast-msg">
        <span class="toast-dot"></span>
        <span>{{ toastMessage() }}</span>
      </div>
    }
  `
})
export class LandingComponent implements OnInit {
  pageTitle = signal<string>('Next-Generation Enterprise Portal');
  pageDesc = signal<string>('Experience unparalleled speeds, custom branding, and server-isolated security. Built natively to run offline in corporate environments.');

  formSubmitted = signal<boolean>(false);
  toastMessage = signal<string | null>(null);

  ngOnInit() {
    if (typeof window !== 'undefined') {
      // 1. Đọc dữ liệu từ localStorage trước
      const rawData = localStorage.getItem('preview_data');
      if (rawData) {
        try {
          const data = JSON.parse(rawData);
          if (data.title) this.pageTitle.set(data.title);
          if (data.desc) this.pageDesc.set(data.desc);
          return;
        } catch (e) {}
      }

      // 2. Dự phòng: Đọc từ URL Query Parameters nếu localStorage trống
      const params = new URLSearchParams(window.location.search);
      const title = params.get('title');
      const desc = params.get('desc');
      if (title) this.pageTitle.set(title);
      if (desc) this.pageDesc.set(desc);
    }
  }

  triggerAction(action: string) {
    this.showToast(action);
  }

  submitForm() {
    this.formSubmitted.set(true);
    this.showToast('Inquiry request captured!');
    setTimeout(() => this.formSubmitted.set(false), 5000);
  }

  showToast(message: string) {
    this.toastMessage.set(message);
    setTimeout(() => {
      if (this.toastMessage() === message) this.toastMessage.set(null);
    }, 3000);
  }
}
