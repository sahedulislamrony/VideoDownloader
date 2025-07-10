using System;
using System.Globalization;
using Avalonia;
using Avalonia.Data.Converters;

namespace VideoDownloaderApp.Converters
{
    public class EnumToBooleanConverter : IValueConverter
    {
        public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value == null || parameter == null)
                return false;

            string enumValue = value?.ToString() ?? string.Empty;
            string targetValue = parameter?.ToString() ?? string.Empty;

            return enumValue == targetValue;
        }

        public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (parameter == null)
                return AvaloniaProperty.UnsetValue;

            bool useValue = (bool)value!;
            if (useValue)
                return Enum.Parse(targetType, parameter.ToString()!);

            return AvaloniaProperty.UnsetValue;
        }
    }
}
