# WinUI Apps - Performance Comparison - UWP vs WASDK
This project helps create a performance baseline between WinUI2/UWP and WinUI3/WASDK apps by profiling the load of a simple page.

## Getting Started

1. Build and deploy all apps in Release.
2. Run the Powershell script profileperfs.ps1.
3. Add your results to the [Results section](##Results).

## Results

### Desktop (ryzen 5 5600x, 32gb ram) - 50 iterations
||UWP C# | UWP C++ | WASDK C# | WASDK C++
|---|---|---|---|----
|App.OnLaunched|120.12 ms | 121.65 ms | 34.98 ms | 20.37 ms
|SamplePage ctor|122.11 ms  | 122 ms | 72.88 ms | 47.1 ms
|SamplePage_Loaded|132.16 ms | 133.97 ms | 117.67 ms | 127.28 ms

### Desktop (intel i5-6600k, 32gb ram) - 50 iterations
||UWP C# | UWP C++ | WASDK C# | WASDK C++
|---|---|---|---|----
|App.OnLaunched|166.05 ms | 173.33 ms | 76.36 ms | 36.43 ms
|SamplePage ctor|169.60 ms  | 174.01 ms | 139.91 ms | 129.25 ms
|SamplePage_Loaded|187.22 ms | 191.67 ms | 189.68 ms | 196.35 ms

### Laptop (intel i7-1185G7, 16gb ram, plugged) - 50 iterations
||UWP C# | UWP C++ | WASDK C# | WASDK C++
|---|---|---|---|----
|App.OnLaunched|49.62 ms | 50.85 ms | 43.82 ms | 24.76 ms
|SamplePage ctor|51.74 ms  | 51.2 ms | 80.57 ms | 51.34 ms
|SamplePage_Loaded|86.54 ms | 87.13 ms | 122.13 ms | 80.63 ms

### Laptop (intel i7-1185G7, 16gb ram, unplugged) - 50 iterations
||UWP C# | UWP C++ | WASDK C# | WASDK C++
|---|---|---|---|----
|App.OnLaunched|54.63 ms | 57.52 ms | 45.93 ms | 25.51 ms
|SamplePage ctor|56.91 ms  | 57.9 ms | 82.99 ms | 52.79 ms
|SamplePage_Loaded|91.02 ms | 93.42 ms | 128.84 ms | 90.86 ms
