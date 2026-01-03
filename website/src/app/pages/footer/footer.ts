import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { simpleInstagram} from '@ng-icons/simple-icons';


@Component({
  selector: 'app-footer',
  imports: [NgIcon],
  templateUrl: './footer.html',
  styleUrl: './footer.css',
  providers:[
    provideIcons({simpleInstagram})
  ]
})

export class Footer {

  anoAtual = new Date().getFullYear();

}
