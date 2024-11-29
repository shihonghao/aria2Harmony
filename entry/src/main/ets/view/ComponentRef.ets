export default  class ComponentRef<T> {
  value?: T

  bind(ref: T) {
    this.value = ref
  }

  static useRef<T>() {
    return new ComponentRef<T>()
  }
}