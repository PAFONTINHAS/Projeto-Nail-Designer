import { Injectable } from '@angular/core';
import { FirebaseService } from '../firebase-service/firebase-service';
import { addDoc, collection, getDocs, onSnapshot, query, serverTimestamp, snapshotEqual} from 'firebase/firestore';
import { BehaviorSubject, Observable } from 'rxjs';
import { Servico } from '../../models/servico_model';

@Injectable({
  providedIn: 'root',
})
export class ServicosService {
  private servicosSubject = new BehaviorSubject<Servico[]>([]);

  servicos$ = this.servicosSubject.asObservable();
  constructor(private readonly firebaseService: FirebaseService) {
    this.startServicosRealtime();
  }

  private startServicosRealtime() {
    const db = this.firebaseService.db;
    const collectionQuery = query(collection(db, 'servicos'));

    onSnapshot(
      collectionQuery,
      (snapshot) => {
        const servicos = snapshot.docs.map(
          (doc) => ({ id: doc.id, ...doc.data() }) as Servico,
        );

        this.servicosSubject.next(servicos);
      },
      (error) => {
        console.error('Erro na ponte de serviços:', error);
      },
    );

  }
  get valorAtualServicos(): Servico[]{
    return this.servicosSubject.value;
  }

  // getServicos(): Observable<any[]> {
  //   const db = this.firebaseService.db;

  //   const collectionQuery = query(collection(db, 'servicos'));

  //   return new Observable((subscriber) => {
  //     const unsubscribe = onSnapshot(
  //       collectionQuery,
  //       (snapshot) => {
  //         const servicos = snapshot.docs.map((doc) => ({
  //           id: doc.id,
  //           ...doc.data(),
  //         }));
  //         subscriber.next(servicos);
  //       },
  //       (error) => {
  //         subscriber.error(error);
  //       },
  //     );

  //     return () => unsubscribe;
  //   });
  // }

  // async addServicos(servicos: any[]) {
  //   for (const servico of servicos) {
  //     addDoc(collection(this.firebaseService.db, 'servicos'), servico);
  //   }
  // }
}
