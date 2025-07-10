using System;
using System.Globalization;
using Avalonia.Data.Converters;

namespace VideoDownloaderApp.Converters
{
    public class BoolToWidthConverter : IValueConverter
    {
        public object? Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value is bool boolValue && parameter is string param)
            {
                var widths = param.Split(',');
                if (widths.Length == 2 &&
                    double.TryParse(widths[0], out double trueWidth) &&
                    double.TryParse(widths[1], out double falseWidth))
                {
                    return boolValue ? trueWidth : falseWidth;
                }
            }
            return 0;
        }

        public object? ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
