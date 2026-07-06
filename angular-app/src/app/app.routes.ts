import { Routes } from '@angular/router';
import { DashboardComponent } from './dashboard';
import { LandingComponent } from './landing';
import { ProfileComponent } from './profile';

export const routes: Routes = [
  { path: 'dashboard', component: DashboardComponent },
  { path: 'landing', component: LandingComponent },
  { path: 'profile', component: ProfileComponent },
  { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
];
