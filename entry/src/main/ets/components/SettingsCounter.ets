import { CounterType, CounterComponent } from '@kit.ArkUI';

@Component
export struct SettingsCounter {
  @Link value: number;

  build() {
    Column() {
      CounterComponent({
        options: {
          type: CounterType.COMPACT,
          numberOptions: {
            label: $r('app.string.recent'),
            value: this.value,
            min: 1,
            max: 8,
            step: 1,
            onChange: (v: number): void => {
              this.value = v;
            }
          }
        }
      })
    }
    .width('90%')
  }
}