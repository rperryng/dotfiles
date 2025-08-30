#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import $ from 'jsr:@david/dax';
import { exists } from "jsr:@std/fs/exists";

const DESIRED_LOGIN_APPS = [
  'Ice',
  'Rectangle',
  'Maccy',
  'Karabiner-Elements',
  'LinearMouse',
  'Easy Move+Resize',
];

const EXISTING_LOGIN_APPS =
  (await $`osascript -e 'tell application "System Events" to get the name of every login item'`
    .text()).split(', ');

$.log(`existing login apps: ${EXISTING_LOGIN_APPS}`);

for (const app of DESIRED_LOGIN_APPS) {
  if (EXISTING_LOGIN_APPS.includes(app)) {
    $.log(`'${app}' already configured to open at login`);
    continue;
  }

  const appPath = `/Applications/${app}.app`.replaceAll(' ', '\\ ');
  if (!exists(appPath)) {
    throw new Error(`Expected ${app} to exist at '${appPath}' but this filepath does not exist`);
  }

  $.log(`Adding ${app} to open at login`);
  await $`osascript -e 'tell application "System Events" to make login item at end with properties {path:"${appPath}", hidden:false}'`;
}
