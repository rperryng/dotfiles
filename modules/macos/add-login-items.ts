#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import $ from 'jsr:@david/dax';

const DESIRED_LOGIN_APPS = [
  'Ice',
  'Easy Move+Resize',
  'Rectangle',
  'Maccy',
  'Karabiner-Elements',
];

const EXISTING_LOGIN_APPS =
  (await $`osascript -e 'tell application "System Events" to get the name of every login item'`
    .text()).split(', ');

for (const app of EXISTING_LOGIN_APPS) {
  if (EXISTING_LOGIN_APPS.includes(app)) {
    $.log(`'${app}' already configured to open at login`);
    continue;
  }

  $.log(`Adding ${app} to open at login`);
  const appPath = `/Applications/${app}.app`;
  await $`osascript -e 'tell application "System Events" to make login item at end with properties {path:"${appPath}", hidden:false}'`;
}
