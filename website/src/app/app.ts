import { Component, signal } from '@angular/core';
import { LucideAngularModule, FileIcon } from 'lucide-angular';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, LucideAngularModule],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('projeto-nail-designer');
  readonly FileIcon = FileIcon;
}
