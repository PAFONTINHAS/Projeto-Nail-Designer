import {
  ApplicationConfig,
  provideBrowserGlobalErrorListeners,
  provideZoneChangeDetection,
  LOCALE_ID,
} from '@angular/core';
import { provideEnvironmentNgxMask } from 'ngx-mask';
import { provideRouter } from '@angular/router';
import { registerLocaleData } from '@angular/common';
import localePt from '@angular/common/locales/pt';
import { routes } from './app.routes';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';

registerLocaleData(localePt);
export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideEnvironmentNgxMask(),
    {provide: MAT_DATE_LOCALE, useValue:'pt-BR'},
    {provide: LOCALE_ID, useValue:'pt-BR'}
  ],
};
