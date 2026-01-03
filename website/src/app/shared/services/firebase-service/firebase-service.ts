import { Injectable } from '@angular/core';
import { initializeApp } from 'firebase/app';
import {Analytics, initializeAnalytics} from 'firebase/analytics'
import {getFirestore} from 'firebase/firestore'
import { firebaseConfig } from '../../../environments/firebase-config';

@Injectable({
  providedIn: 'root',
})
export class FirebaseService {

  app = initializeApp(firebaseConfig);
  analytics = initializeAnalytics(this.app);
  db = getFirestore(this.app);
  
  constructor(){}
  
}
