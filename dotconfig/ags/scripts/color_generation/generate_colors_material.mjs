#!/usr/bin/env zx

import {
  argbFromHex,
  argbFromRgb,
  hexFromArgb,
  QuantizerCelebi,
  Score,
  SchemeTonalSpot,
  Hct,
  MaterialDynamicColors,
} from "@material/material-color-utilities";
import sharp from "sharp";

const pathFlag = argv.path;
const colorFlag = argv.color;

if (pathFlag && colorFlag) {
  await $`echo "Only one of --path or --color is allowed"`.pipe(process.stderr);
}

const generateThemeFromSourceColor = (color, isDark) => {
  const scheme = new SchemeTonalSpot(Hct.fromInt(color), isDark, 0.0);
  const getHexColor = (dynamicColor) =>
    hexFromArgb(dynamicColor.getArgb(scheme));
  echo`$primary: ${getHexColor(MaterialDynamicColors.primary)};`;
  echo`$onPrimary: ${getHexColor(MaterialDynamicColors.onPrimary)};`;
  echo`$primaryContainer: ${getHexColor(
    MaterialDynamicColors.primaryContainer,
  )};`;
  echo`$onPrimaryContainer: ${getHexColor(
    MaterialDynamicColors.onPrimaryContainer,
  )};`;
  echo`$seconary: ${getHexColor(MaterialDynamicColors.secondary)};`;
  echo`$onSecondary: ${getHexColor(MaterialDynamicColors.onSecondary)};`;
  echo`$secondaryContainer: ${getHexColor(
    MaterialDynamicColors.secondaryContainer,
  )};`;
  echo`$onSecondaryContainer: ${getHexColor(
    MaterialDynamicColors.onSecondaryContainer,
  )};`;
  echo`$tertiary: ${getHexColor(MaterialDynamicColors.tertiary)};`;
  echo`$onTertiary: ${getHexColor(MaterialDynamicColors.onTertiary)};`;
  echo`$tertiaryContainer: ${getHexColor(
    MaterialDynamicColors.tertiaryContainer,
  )};`;
  echo`$onTertiaryContainer: ${getHexColor(
    MaterialDynamicColors.onTertiaryContainer,
  )};`;
  echo`$error: ${getHexColor(MaterialDynamicColors.error)};`;
  echo`$onError: ${getHexColor(MaterialDynamicColors.onError)};`;
  echo`$errorContainer: ${getHexColor(MaterialDynamicColors.errorContainer)};`;
  echo`$onErrorContainer: ${getHexColor(
    MaterialDynamicColors.onErrorContainer,
  )};`;
  echo`$background: ${getHexColor(MaterialDynamicColors.background)};`;
  echo`$onBackground: ${getHexColor(MaterialDynamicColors.onBackground)};`;
  echo`$surface: ${getHexColor(MaterialDynamicColors.surface)};`;
  echo`$onSurface: ${getHexColor(MaterialDynamicColors.onSurface)};`;
  echo`$onSurfaceVariant: ${getHexColor(
    MaterialDynamicColors.onSurfaceVariant,
  )};`;
  echo`$surfaceContainerLowest: ${getHexColor(
    MaterialDynamicColors.surfaceContainerLowest,
  )};`;
  echo`$surfaceContainerLow: ${getHexColor(
    MaterialDynamicColors.surfaceContainerLow,
  )};`;
  echo`$surfaceContainer: ${getHexColor(
    MaterialDynamicColors.surfaceContainer,
  )};`;
  echo`$surfaceContainerHigh: ${getHexColor(
    MaterialDynamicColors.surfaceContainerHigh,
  )};`;
  echo`$surfaceContainerHighest: ${getHexColor(
    MaterialDynamicColors.surfaceContainerHighest,
  )};`;
  echo`$inverseSurface: ${getHexColor(MaterialDynamicColors.inverseSurface)};`;
  echo`$inverseOnSurface: ${getHexColor(
    MaterialDynamicColors.inverseOnSurface,
  )};`;
  echo`$outline: ${getHexColor(MaterialDynamicColors.outline)};`;
  echo`$outlineVariant: ${getHexColor(MaterialDynamicColors.outlineVariant)};`;
  echo`$shadow: ${getHexColor(MaterialDynamicColors.shadow)};`;
};

if (pathFlag) {
  const { data, info } = await sharp(pathFlag)
    .resize({ width: 64 })
    .toBuffer({ resolveWithObject: true });
  const imageBytes = new Uint8ClampedArray(data.buffer);

  // Convert Image data to Pixel Array
  const pixels = [];
  for (let i = 0; i < imageBytes.length; i += 4) {
    const r = imageBytes[i];
    const g = imageBytes[i + 1];
    const b = imageBytes[i + 2];
    const a = imageBytes[i + 3];
    if (a < 255) {
      continue;
    }
    const argb = argbFromRgb(r, g, b);
    pixels.push(argb);
  }

  // Convert Pixels to Material Colors
  const result = QuantizerCelebi.quantize(pixels, 128);
  const ranked = Score.score(result);
  const primaryColor = ranked[0];
  generateThemeFromSourceColor(primaryColor, argv.l);
} else if (colorFlag) {
  generateThemeFromSourceColor(argbFromHex(colorFlag), argv.l);
} else {
  // TODO: generate color from swww img
}
