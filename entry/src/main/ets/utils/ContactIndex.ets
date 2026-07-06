import { Contact } from '../model/Contact';

export interface ContactIndexResult {
  letters: string[];
  letterFirst: number[];
  contactLetter: number[];
}

function letterOf(name: string): string {
  if (name.length === 0) {
    return '#';
  }
  const ch: string = name.charAt(0).toUpperCase();
  return (ch >= 'A' && ch <= 'Z') ? ch : '#';
}

export function buildContactIndex(sortedContacts: Contact[]): ContactIndexResult {
  const letters: string[] = [];
  const letterFirst: number[] = [];
  const contactLetter: number[] = [];

  sortedContacts.forEach((c: Contact, i: number): void => {
    const ch: string = letterOf(c.name);
    let li: number = letters.indexOf(ch);
    if (li < 0) {
      letters.push(ch);
      letterFirst.push(i);
      li = letters.length - 1;
    }
    contactLetter.push(li);
  });

  if (letters.length === 0) {
    letters.push('#');
    letterFirst.push(0);
  }

  return { letters, letterFirst, contactLetter };
}