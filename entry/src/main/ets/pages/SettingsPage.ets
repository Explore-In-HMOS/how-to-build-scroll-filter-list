import { SettingsCounter } from '../components/SettingsCounter';
import { NavigationService } from '../services/NavigationService';

@Component
export struct SettingsPage {
  @StorageLink('maxRecent') maxRecent: number = 3;
  private navigationService: NavigationService = NavigationService.getInstance();

  build() {
    Column({ space: 10 }) {
      Text($r('app.string.settings_title'))
        .fontSize(18)
        .fontWeight(700)
        .fontColor($r('app.color.text_primary'))
      Text($r('app.string.recent_contacts_shown'))
        .fontSize(12)
        .fontColor($r('app.color.text_secondary'))
        .textAlign(TextAlign.Center)
      SettingsCounter({
        value: $maxRecent
      })
      Text(this.getUIContext().getHostContext()?.resourceManager
      ?.getStringSync($r('app.string.showing_up_to').id, this.maxRecent) ?? '')
        .fontSize(11)
        .fontColor($r('app.color.text_highlight'))
        .textAlign(TextAlign.Center)

      Button($r('app.string.action_back'))
        .fontSize(13)
        .fontColor($r('app.color.text_primary'))
        .height(40)
        .width('40%')
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.brand_primary'))
        .onClick((): void => {
          this.navigationService.back();
        })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 26, right: 26 })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.background_primary'))
  }
}