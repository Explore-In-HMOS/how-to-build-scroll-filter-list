import { ArcAlphabetIndexer, ColorMetrics, LengthMetrics } from '@kit.ArkUI';

@Component
export struct AlphabetNavigation {
  @Prop letters: string[] = ['#'];
  @Prop selectedLetter: number = 0;
  onSelectLetter: (letterIndex: number) => void = (letterIndex: number): void => {
  };

  build() {
    ArcAlphabetIndexer({ arrayValue: this.letters, selected: 0 })
      .autoCollapse(true)
      .usePopup(false)
      .selected(this.selectedLetter)
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.Transparent)
      .color(ColorMetrics.resourceColor($r('app.color.indexer_normal')))
      .selectedColor(ColorMetrics.resourceColor($r('app.color.text_primary')))
      .selectedBackgroundColor(ColorMetrics.resourceColor($r('app.color.brand_primary')))
      .font({
        size: '11.0fp',
        style: FontStyle.Normal,
        weight: 500,
        family: 'HarmonyOS Sans'
      })
      .selectedFont({
        size: '12.0fp',
        style: FontStyle.Normal,
        weight: 600,
        family: 'HarmonyOS Sans'
      })
      .onSelect((index: number): void => {
        this.onSelectLetter(index);
      })
  }
}