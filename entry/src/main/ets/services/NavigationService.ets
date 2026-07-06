@ObservedV2
export class NavigationService {
  static _instance: NavigationService;
  @Trace pageInfos: NavPathStack = new NavPathStack();
  @Trace pageList: PageModel[] = [];

  static getInstance(): NavigationService {
    if (!NavigationService._instance) {
      NavigationService._instance = new NavigationService();
    }
    return NavigationService._instance;
  }

  navigateTo(name: string): void {
    this.pageInfos.pushPath({ name: name });
  }

  navigateToWithArgs(name: string, param: string): void {
    this.pageInfos.pushPath({ name: name, param: param });
  }

  navigateToWithObjectArgs(name: string, param: object): void {
    this.pageInfos.pushPath({ name: name, param: param });
  }

  back(): void {
    this.pageInfos.pop();
  }

  clearStackAndNavigate(name: string): void {
    this.pageInfos.clear();
    this.pageInfos.pushPath({ name: name });
  }
}

export class PageModel {
  page: () => void;
  pageRoute: string = '';

  constructor(page: () => void, pageRoute: string) {
    this.page = page;
    this.pageRoute = pageRoute;
  }
}

export enum Page {
  CONTACTS_PAGE = 'ContactsPage',
  SETTINGS_PAGE = 'SettingsPage'
}