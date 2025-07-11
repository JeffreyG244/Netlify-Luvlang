import { FC, PropsWithChildren } from 'react'

declare global {
  type FCC<P = object> = FC<PropsWithChildren<P>> & {
    propTypes?: any
    defaultProps?: Partial<P>
  }
}
