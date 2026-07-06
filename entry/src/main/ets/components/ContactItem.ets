import { Contact, ContactType } from '../model/Contact';

@Component
export struct ContactItem {
  @Prop contact: Contact;
  @Prop active: boolean = false;
  @Prop selectionMode: boolean = false;
  @Prop selected: boolean = false;
  @Prop isRecent: boolean = false;
  alphaIndex: number = -1;
  onCheck: (alphaIndex: number, value: boolean) => void =
    (alphaIndex: number, value: boolean): void => {
    };

  private typeSymbol(): Resource {
    switch (this.contact.type) {
      case ContactType.WORK:
        return $r('sys.symbol.briefcase');
      case ContactType.HOME:
        return $r('sys.symbol.house');
      case ContactType.MOBILE:
      default:
        return $r('sys.symbol.phone');
    }
  }

  private bgColor(): ResourceColor {
    return (this.useMarquee()) ? $r('app.color.brand_primary') : $r('app.color.surface_item');
  }

  private borderW(): number {
    return (this.selectionMode && this.selected) ? 1.5 : 0;
  }

  private useMarquee(): boolean {
    return this.active && !this.selectionMode;
  }

  build() {
    Row({ space: 12 }) {
      if (this.selectionMode && !this.isRecent) {
        Checkbox({ name: this.contact.id, group: 'contactsGroup' })
          .select(this.selected)
          .selectedColor($r('app.color.brand_primary'))
          .shape(CheckBoxShape.CIRCLE)
          .width(22)
          .height(22)
          .onChange((value: boolean): void => {
            this.onCheck(this.alphaIndex, value);
          })
      }

      Text() {
        SymbolSpan(this.typeSymbol())
          .fontSize(16)
          .fontColor(
            [(!this.selectionMode && this.active) ? $r('app.color.text_primary') : $r('app.color.symbol_inactive')])
      }

      if (this.isRecent) {
        Text() {
          SymbolSpan($r('sys.symbol.clock'))
            .fontSize(13)
            .fontColor([$r('app.color.text_highlight')])
        }
      }

      if (this.useMarquee()) {
        Marquee({
          start: true,
          step: 6,
          loop: -1,
          fromStart: true,
          src: this.contact.name
        })
          .layoutWeight(1)
          .height(22)
          .fontColor($r('app.color.text_primary'))
          .fontSize(15)
          .fontWeight(600)
          .fontFamily('HarmonyOS Sans')
      } else {
        Text(this.contact.name)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor(
            (!this.selectionMode && this.active) ? $r('app.color.text_primary') : $r('app.color.text_inactive'))
          .fontSize(15)
          .fontWeight(this.active ? 600 : 400)
          .fontFamily('HarmonyOS Sans')
          .textAlign(TextAlign.Start)
      }
    }
    .width('414px')
    .height(52)
    .padding({ left: 18, right: 18 })
    .borderRadius(26)
    .backgroundColor(this.bgColor())
    .border({ width: this.borderW(), color: $r('app.color.brand_primary') })
    .alignItems(VerticalAlign.Center)
  }
}