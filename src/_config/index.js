let url =
  process.env.NODE_ENV === 'production'
    ? process.env.REACT_APP_BE_PROD
    : process.env.REACT_APP_BE_DEV

const config = {
  navigationType: 'hash', // or 'history'
  useSampleData: true,
  api: {
    url: url,
  },
}

export default config
