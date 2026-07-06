import { Component, signal, OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  imports: [],
  templateUrl: './app.html',
  styleUrl: './app.css',
  standalone: true
})
export class App implements OnInit {
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
        } catch (e) {
          console.error('Error parsing preview_data from localStorage', e);
        }
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
