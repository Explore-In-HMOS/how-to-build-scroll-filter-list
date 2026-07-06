import { NavigationService, Page } from '../services/NavigationService';
import { ContactsPage } from './ContactsPage';
import { SettingsPage } from './SettingsPage';


@Entry
@Component
struct NavigationPage {
  navigationService: NavigationService = NavigationService.getInstance();

  aboutToAppear(): void {
    AppStorage.setOrCreate('maxRecent', 3);
  }

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === Page.CONTACTS_PAGE) {
        ContactsPage()
      } else if (name === Page.SETTINGS_PAGE) {
        SettingsPage()
      }
    }

    .hideTitleBar(true)
  }

  build() {
    Navigation(this.navigationService.pageInfos)
      .onAppear(() => {
        this.navigationService.navigateTo(Page.CONTACTS_PAGE);
      })
      .mode(NavigationMode.Stack)
      .navDestination(this.routeMap)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
      .hideTitleBar(true)
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_primary'))
  }
}