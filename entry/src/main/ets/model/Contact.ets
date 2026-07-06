export enum ContactType {
  MOBILE = 'mobile',
  WORK = 'work',
  HOME = 'home'
}

export interface Contact {
  id: string;
  name: string;
  type: ContactType;
  lastInteractionTs: number;
}

export interface ContactRow {
  contact: Contact;
  isRecent: boolean;
  alphaIndex: number;
}