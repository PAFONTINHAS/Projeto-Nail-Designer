import { Component } from '@angular/core';
import { Header } from "../header/header";
import { Banner } from "../banner/banner";
import { ServicosPrecos } from "../servicos-precos/servicos-precos";
import { Agendamentos } from "../agendamentos/agendamentos";
import { Contato } from "../contato/contato";
import { Footer } from "../footer/footer";

@Component({
  selector: 'app-main',
  imports: [Header, Banner, ServicosPrecos, Agendamentos, Contato, Footer],
  templateUrl: './main.html',
  styleUrl: './main.css',
})
export class Main {

}
