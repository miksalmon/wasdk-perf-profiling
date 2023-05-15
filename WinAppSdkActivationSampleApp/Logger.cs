using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Channels;
using System.Threading.Tasks;
using Windows.Foundation.Diagnostics;

namespace WinAppSdkActivationSampleApp
{
    public class Logger
    {
        private static readonly Lazy<Logger> LazyInstance = new Lazy<Logger>();

        public static Logger Instance => LazyInstance.Value;

        private readonly LoggingChannel _loggingChannel;
        private readonly Stopwatch _stopwatch;

        public Logger()
        {
            _loggingChannel = new LoggingChannel("LoggingChannel", null, new Guid("2e0582f3-d1b6-516a-9de3-9fd79ef952f8"));
            _stopwatch = Stopwatch.StartNew();
        }

        public void Log(string eventName)
        {
            var fields = new LoggingFields();
            fields.AddString(nameof(eventName), eventName);
            fields.AddDouble("timeElapsed", _stopwatch.Elapsed.TotalMilliseconds);
            _loggingChannel.LogEvent(
                eventName,
                fields);
        }
    }
}
