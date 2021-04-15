dates = pd.date_range('1/10/2021', periods=100, freq='H')
sales = np.random.randint(100, 500, size=len(dates))

ts = pd.Series(data=sales, index=dates, name='sales')

print(ts.resample('D').last())

print(ts.resample('D').ohlc())

# simnilar output
print(pd.date_range(start='1/10/2021', periods=10, freq='D'))

print(pd.date_range(start='1-10-2021', periods=10, freq='D'))

print(pd.date_range(start='10-JAN-2021', periods=10, freq='D'))

print(pd.date_range(start='2021-1-10', periods=10, freq='D'))

# using multiples
print(pd.date_range(start='1/10/2021', periods=10, freq='2D'))
