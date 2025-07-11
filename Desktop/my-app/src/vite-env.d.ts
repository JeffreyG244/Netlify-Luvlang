/// <reference types="vite/client" />
declare module "*";
declare module "@/*";

declare module 'class-variance-authority' {
  export interface VariantProps<T> {
    variant?: keyof T
  }
}
declare module 'react-router-dom' {
  export * from 'react-router-dom/dist/index'
}
declare module 'react-router-dom' {
  export * from 'react-router-dom'
}
declare module 'class-variance-authority' {
  const cva: (base: string, config?: any) => string
  export { cva }
}
