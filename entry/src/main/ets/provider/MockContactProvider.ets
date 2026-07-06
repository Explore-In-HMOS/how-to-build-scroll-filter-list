import { Contact, ContactType } from '../model/Contact';

export class MockContactProvider {
  private static readonly DATA: Contact[] = [
    {
      id: 'c01',
      name: 'Aaron Bell',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000010
    },
    {
      id: 'c02',
      name: 'Adriana Fernández-Villalobos',
      type: ContactType.WORK,
      lastInteractionTs: 1717000120
    },
    {
      id: 'c03',
      name: 'Alex Park',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000900
    },
    {
      id: 'c04',
      name: 'Bianca Russo',
      type: ContactType.HOME,
      lastInteractionTs: 1717000030
    },
    {
      id: 'c05',
      name: 'Carlos Mendoza',
      type: ContactType.WORK,
      lastInteractionTs: 1717000700
    },
    {
      id: 'c06',
      name: 'Chloe Andersen',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000850
    },
    {
      id: 'c07',
      name: "Daniel O'Sullivan",
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000050
    },
    {
      id: 'c08',
      name: 'Ekaterina Voskoboynikova',
      type: ContactType.WORK,
      lastInteractionTs: 1717000060
    },
    {
      id: 'c09',
      name: 'Emma Thompson',
      type: ContactType.HOME,
      lastInteractionTs: 1717000950
    },
    {
      id: 'c10',
      name: 'Faisal Al-Rashid',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000070
    },
    {
      id: 'c11',
      name: 'Grace Liu',
      type: ContactType.WORK,
      lastInteractionTs: 1717000600
    },
    {
      id: 'c12',
      name: 'Hiroshi Tanaka',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000080
    },
    {
      id: 'c13',
      name: 'Isabella Castellano-Moretti',
      type: ContactType.HOME,
      lastInteractionTs: 1717000090
    },
    {
      id: 'c14',
      name: 'Jack Murphy',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000800
    },
    {
      id: 'c15',
      name: 'Karim Boutros',
      type: ContactType.WORK,
      lastInteractionTs: 1717000100
    },
    {
      id: 'c16',
      name: 'Liam Walker',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000110
    },
    {
      id: 'c17',
      name: 'Maximilian Featherstonehaugh',
      type: ContactType.WORK,
      lastInteractionTs: 1717000999
    },
    {
      id: 'c18',
      name: 'Noah Kim',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000115
    },
    {
      id: 'c19',
      name: 'Olivia Brown',
      type: ContactType.HOME,
      lastInteractionTs: 1717000125
    },
    {
      id: 'c20',
      name: 'Priya Venkataraman',
      type: ContactType.WORK,
      lastInteractionTs: 1717000130
    },
    {
      id: 'c21',
      name: 'Quentin Lefebvre',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000135
    },
    {
      id: 'c22',
      name: 'Rachel Green',
      type: ContactType.HOME,
      lastInteractionTs: 1717000750
    },
    {
      id: 'c23',
      name: 'Sofia Rossi',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000140
    },
    {
      id: 'c24',
      name: 'Theodore Blackwood',
      type: ContactType.WORK,
      lastInteractionTs: 1717000145
    },
    {
      id: 'c25',
      name: '3M Logistics Front Office',
      type: ContactType.WORK,
      lastInteractionTs: 1717000150
    },
    {
      id: 'c26',
      name: 'Zoë Nakamura',
      type: ContactType.MOBILE,
      lastInteractionTs: 1717000650
    }
  ];

  public static getContacts(): Contact[] {
    return MockContactProvider.DATA.slice().sort((a: Contact, b: Contact): number => {
      const an: string = a.name.toUpperCase();
      const bn: string = b.name.toUpperCase();
      if (an < bn) {
        return -1;
      }
      if (an > bn) {
        return 1;
      }
      return 0;
    });
  }

  public static getRecentContacts(limit: number): Contact[] {
    const safeLimit: number = limit < 0 ? 0 : limit;
    return MockContactProvider.DATA.slice()
      .sort((a: Contact, b: Contact): number => b.lastInteractionTs - a.lastInteractionTs)
      .slice(0, safeLimit);
  }
}