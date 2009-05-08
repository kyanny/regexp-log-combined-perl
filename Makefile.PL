use inc::Module::Install;

name     'Regexp-Log-Combined';
all_from 'lib/Regexp::Log::Combined';
author   'Kensuke Kaneko <kyanny@gmail.com>';

requires       'Regexp::Log';
build_requires 'Test::More';

auto_install;

WriteAll;

