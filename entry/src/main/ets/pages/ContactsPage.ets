import {
  ArcList, ArcListItem, ComponentContent, LengthMetrics, CircleShape
} from '@kit.ArkUI';
import { Contact, ContactRow } from '../model/Contact';
import { MockContactProvider } from '../provider/MockContactProvider';
import { buildContactIndex, ContactIndexResult } from '../utils/ContactIndex';
import { ContactItem } from '../components/ContactItem';
import { AlphabetNavigation } from '../components/AlphabetNavigation';
import { NavigationService, Page } from '../services/NavigationService';

const WATCH_SIZE: string = '466px';
const CONTROL_COUNT: number = 1;

@Builder
function buildHeader() {
  Column({ space: 2 }) {
    Text($r('app.string.contacts_title'))
      .fontSize(17).fontWeight(700).fontColor($r('app.color.text_primary'))
    Text(AppStorage.get<string>('recentText') ?? '')
      .fontSize(11).fontColor($r('app.color.text_secondary'))
  }
  .width('100%')
  .padding({ top: 20 })
  .alignItems(HorizontalAlign.Center)
}

@Component
export struct ContactsPage {
  @StorageLink('maxRecent') @Watch('rebuildRows') maxRecent: number = 3;
  private navigationService: NavigationService = NavigationService.getInstance();
  private contacts: Contact[] = [];
  private indexResult: ContactIndexResult = { letters: ['#'], letterFirst: [0], contactLetter: [] };
  private scroller: Scroller = new Scroller();
  private headerContent: ComponentContent<Object> =
    new ComponentContent(this.getUIContext(), wrapBuilder(buildHeader));
  @State rows: ContactRow[] = [];
  @State selected: boolean[] = [];
  @State isSelectAll: boolean = false;
  @State selectionMode: boolean = false;
  @State selectedLetter: number = 0;
  @State activeIndex: number = 0;
  @State batchMessage: string = '';
  recentCount: number = 0;

  aboutToAppear(): void {
    this.contacts = MockContactProvider.getContacts();
    this.indexResult = buildContactIndex(this.contacts);
    this.selected = this.contacts.map((): boolean => false);
    this.rebuildRows();
  }

  private rebuildRows(): void {
    const recent: Contact[] = MockContactProvider.getRecentContacts(this.maxRecent);
    this.recentCount = recent.length;
    AppStorage.setOrCreate('recentCount', this.recentCount);

    const recentText: string = this.getUIContext().getHostContext()?.resourceManager
    ?.getStringSync($r('app.string.recent_prefix').id, this.recentCount) ?? '';
    AppStorage.setOrCreate('recentText', recentText);
    this.headerContent.update({});

    const recentRows: ContactRow[] = recent.map((c: Contact): ContactRow => {
      return { contact: c, isRecent: true, alphaIndex: -1 };
    });
    const alphaRows: ContactRow[] = this.contacts.map((c: Contact, i: number): ContactRow => {
      return { contact: c, isRecent: false, alphaIndex: i };
    });
    this.rows = recentRows.concat(alphaRows);
  }

  private firstAlphaListIndex(): number {
    return CONTROL_COUNT + this.recentCount;
  }

  private handleCenterChange(centerIndex: number): void {
    this.activeIndex = centerIndex;
    const alphaIndex: number = centerIndex - this.firstAlphaListIndex();
    if (alphaIndex >= 0 && alphaIndex < this.indexResult.contactLetter.length) {
      this.selectedLetter = this.indexResult.contactLetter[alphaIndex];
    }
  }

  private handleLetterSelect(letterIndex: number): void {
    this.selectedLetter = letterIndex;
    if (letterIndex >= 0 && letterIndex < this.indexResult.letterFirst.length) {
      const target: number = this.firstAlphaListIndex() + this.indexResult.letterFirst[letterIndex];
      this.scroller.scrollToIndex(target);
      this.activeIndex = target;
    }
  }

  private toggleSelectAll(): void {
    this.isSelectAll = !this.isSelectAll;
    const next: boolean = this.isSelectAll;
    this.selected = this.contacts.map((): boolean => next);
  }

  private handleItemCheck(alphaIndex: number, value: boolean): void {
    if (alphaIndex < 0 || alphaIndex >= this.selected.length) {
      return;
    }
    const updated: boolean[] = this.selected.slice();
    updated[alphaIndex] = value;
    this.selected = updated;
    this.isSelectAll = updated.every((v: boolean): boolean => v === true);
  }

  private selectedCount(): number {
    return this.selected.filter((v: boolean): boolean => v === true).length;
  }

  private runBatchOperation(): void {
    const count: number = this.selectedCount();
    this.batchMessage = this.getUIContext().getHostContext()?.resourceManager
    ?.getStringSync($r('app.string.batch_processed').id, count) ?? '';
    this.isSelectAll = false;
    this.selected = this.contacts.map((): boolean => false);
    this.selectionMode = false;
  }

  private isSelectedAlpha(alphaIndex: number): boolean {
    if (alphaIndex < 0 || alphaIndex >= this.selected.length) {
      return false;
    }
    return this.selected[alphaIndex];
  }

  @Builder
  private ControlContent() {
    if (!this.selectionMode) {
      Column({ space: 10 }) {
        Row({ space: 12 }) {
          Button($r('app.string.action_select'))
            .fontSize(13)
            .fontColor($r('app.color.text_primary'))
            .height(40)
            .layoutWeight(1)
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.button_secondary'))
            .onClick((): void => {
              this.selectionMode = true;
              this.batchMessage = '';
            })
          Button($r('app.string.action_settings'))
            .fontSize(13)
            .fontColor($r('app.color.text_primary'))
            .height(40)
            .layoutWeight(1)
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.button_secondary'))
            .onClick((): void => {
              this.navigationService.navigateTo(Page.SETTINGS_PAGE);
            })
        }
        .width('100%')

        if (this.batchMessage.length > 0) {
          Text(this.batchMessage).fontSize(10).fontColor($r('app.color.text_success'))
        }
      }
      .width('78%')
      .padding({ bottom: 12 })
      .alignItems(HorizontalAlign.Center)
    } else {
      Column({ space: 10 }) {
        Row({ space: 6 }) {
          Row({ space: 6 }) {
            CheckboxGroup({ group: 'contactsGroup' })
              .selectAll(this.isSelectAll)
              .selectedColor($r('app.color.brand_primary'))
              .checkboxShape(CheckBoxShape.CIRCLE)
              .hitTestBehavior(HitTestMode.None)
              .width(22)
              .height(22)
              .margin({ right: 0 })
            Text(this.selectedCount() + '')
              .fontSize(12)
              .fontColor($r('app.color.text_primary'))
              .width(18)
              .textAlign(TextAlign.Center)
          }
          .onClick((): void => {
            this.toggleSelectAll();
          })

          Button($r('app.string.action_apply'))
            .fontSize(13)
            .fontColor($r('app.color.text_primary'))
            .height(40)
            .width(80)
            .type(ButtonType.Capsule)
            .enabled(this.selectedCount() > 0)
            .backgroundColor(
              this.selectedCount() > 0 ? $r('app.color.brand_primary') : $r('app.color.button_secondary'))
            .onClick((): void => {
              this.runBatchOperation();
            })

          Button({ type: ButtonType.Circle }) {
            Text() {
              SymbolSpan($r('sys.symbol.xmark')).fontSize(14).fontColor([$r('app.color.text_primary')])
            }
          }
          .width(36)
          .height(36)
          .backgroundColor($r('app.color.button_secondary'))
          .onClick((): void => {
            this.selectionMode = false;
          })
        }
        .justifyContent(FlexAlign.Center)
        .padding({ right: 14 })
      }
      .width('100%')
      .padding({ bottom: 12 })
      .alignItems(HorizontalAlign.Center)
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column()
        .width(WATCH_SIZE)
        .height(WATCH_SIZE)
        .clipShape(new CircleShape({ width: '100%', height: '100%' }))
        .backgroundColor($r('app.color.background_primary'))

      ArcList({ scroller: this.scroller, initialIndex: 0, header: this.headerContent }) {
        ArcListItem() {
          this.ControlContent()
        }.align(Alignment.Center)

        ForEach(this.rows, (row: ContactRow, index: number) => {
          ArcListItem() {
            ContactItem({
              contact: row.contact,
              active: (CONTROL_COUNT + index) === this.activeIndex,
              selectionMode: this.selectionMode,
              selected: this.isSelectedAlpha(row.alphaIndex),
              isRecent: row.isRecent,
              alphaIndex: row.alphaIndex,
              onCheck: (alphaIndex: number, value: boolean): void => {
                this.handleItemCheck(alphaIndex, value);
              }
            })
          }.align(Alignment.Center)
        }, (row: ContactRow, index: number): string => (row.isRecent ? 'r-' : 'a-') + row.contact.id)

        ArcListItem() {
          Row().width('100%').height(40)
        }.align(Alignment.Center)
      }
      .scrollBar(BarState.Off)
      .space(LengthMetrics.px(10))
      .width(WATCH_SIZE)
      .height(WATCH_SIZE)
      .borderRadius(WATCH_SIZE)
      .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number): void => {
        this.handleCenterChange(centerIndex);
      })

      AlphabetNavigation({
        letters: this.indexResult.letters,
        selectedLetter: this.selectedLetter,
        onSelectLetter: (letterIndex: number): void => {
          this.handleLetterSelect(letterIndex);
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_primary'))
  }
}