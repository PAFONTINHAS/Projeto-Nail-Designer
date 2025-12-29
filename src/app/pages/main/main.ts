import { Component } from '@angular/core';
import { Header } from "../header/header";
import { Banner } from "../banner/banner";

@Component({
  selector: 'app-main',
  imports: [Header, Banner],
  templateUrl: './main.html',
  styleUrl: './main.css',
})
export class Main {

}
