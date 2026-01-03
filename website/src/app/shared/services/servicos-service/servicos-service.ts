import { Injectable } from '@angular/core';
import { FirebaseService } from '../firebase-service/firebase-service';
import { addDoc, collection, getDocs, serverTimestamp} from 'firebase/firestore';

@Injectable({
  providedIn: 'root',
})
export class ServicosService {

  constructor(private readonly firebaseService: FirebaseService){}

  async getServicos(){
    const db = this.firebaseService.db;
    const snapshot = await getDocs(collection(db, 'servicos'));
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));    
  }

  async addServicos( servicos: any[]){

    for (const servico of servicos){
      addDoc(collection(this.firebaseService.db, 'servicos'), servico);
    }

  }
  
}
