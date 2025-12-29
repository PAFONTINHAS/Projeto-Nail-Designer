import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ServicosPrecos } from './servicos-precos';

describe('ServicosPrecos', () => {
  let component: ServicosPrecos;
  let fixture: ComponentFixture<ServicosPrecos>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ServicosPrecos]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ServicosPrecos);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
