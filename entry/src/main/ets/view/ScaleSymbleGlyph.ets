@Component
export struct ScaleSymbolGlyph {
  @Prop @Require source: Resource;
  @State isActive: boolean = false;
  @Prop fontSize: number | string | Resource;

  build() {
    Stack() {
      SymbolGlyph(this.source)
        .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP), this.isActive)
        .fontSize(this.fontSize)
    }.onTouch((touchEvent) => {
      if (touchEvent.type == TouchType.Down) {
        this.isActive = true
        setTimeout(() => {
          this.isActive = false;
        }, 200)
      }
    })
  }
}