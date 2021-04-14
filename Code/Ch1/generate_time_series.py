dates = pd.date_range('1/10/2021', periods=100, freq='H')
sales = np.random.randint(100, 500, size=len(dates))

ts = pd.Series(data=sales, index=dates, name='sales')

ts.resample('D').last()

ts.resample('D').ohlc()

