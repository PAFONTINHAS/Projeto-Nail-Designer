import { Component } from '@angular/core';
import { LucideAngularModule, MapPin, Phone, Clock } from 'lucide-angular';

interface CardInfo{
  icon:any;
  text:string;
  subText:string;
}

@Component({
  selector: 'app-contato',
  imports: [LucideAngularModule],
  templateUrl: './contato.html',
  styleUrl: './contato.css',
})
export class Contato {

  readonly MapPin = MapPin;
  readonly Phone = Phone;
  readonly Clock = Clock;

  cards: CardInfo[] = [
    {
      icon: MapPin,
      text: "Rua da Beleza, 123 - Centro",
      subText: "São Paulo, SP - CEP 01234-567"
    },
    {
      icon: Phone,
      text: "(11) 98765-4321",
      subText: "Whatsapp Disponível"
    },
    {
      icon: Clock,
      text: "Seg - Sex 9h às 20h \n Sáb: 9h às 18h",
      subText:"Domingo: Fechado"
    }
  ]



}
