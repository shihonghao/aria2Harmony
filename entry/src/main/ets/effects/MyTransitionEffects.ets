export  default  class  MyTransitionEffects{
  static OPACITY_SLIDE_START:object=TransitionEffect.opacity(0).combine(
    TransitionEffect.move(TransitionEdge.START)
  ).animation({
    duration:500
  })
  static OPACITY_SLIDE_TOP:object=TransitionEffect.opacity(0).combine(
    TransitionEffect.move(TransitionEdge.TOP)
  ).animation({
    duration:500
  })
  static OPACITY_SLIDE_BOTTOM:object=TransitionEffect.opacity(0).combine(
    TransitionEffect.move(TransitionEdge.BOTTOM)
  ).animation({
    duration:500
  })
  static OPACITY:object=TransitionEffect.opacity(0).combine(
    TransitionEffect.opacity(1)
  ).animation({
    duration:500
  })



}