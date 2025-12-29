import { Component } from '@angular/core';
import { Header } from "../header/header";
import { Banner } from "../banner/banner";
import { ServicosPrecos } from "../servicos-precos/servicos-precos";

@Component({
  selector: 'app-main',
  imports: [Header, Banner, ServicosPrecos],
  templateUrl: './main.html',
  styleUrl: './main.css',
})
export class Main {

}
