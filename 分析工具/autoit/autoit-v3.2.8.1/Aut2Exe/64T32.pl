use strict;
use warnings;

my $f=shift || die ("Gimme a file name!");

print STDERR "Processing '$f':\n";
print STDERR "- Reading 'AutoItSC.bin'\n";
open F,"<AutoItSC.bin";
binmode F;
read F,my $a, -s 'AutoItSC.bin';
close F;

print STDERR "- Reading '$f'\n";
open F,"<$f";
binmode F;
read F,my $d, -s $f;
close F;

print STDERR "- Looking for the script\n";
if ($d=~/\xA3\x48\x4B\xBE\x98\x6C\x4A\xA9\x99\x4C\x53\x0A\x86\xD6\x48\x7D/sg)
{
   my $pd=(pos $d)-16;
   print STDERR "- Script found @ ".sprintf("%08lX",$pd)."\n";
   print STDERR "- Creating 32-bit version '$f.a32.exe'\n";
   open F,">$f.a32.exe";
   binmode F;
   print F $a.substr($d,$pd,length($d)-$pd);
   close F;
}
else
{
   print STDERR "- Script not found !\n";
}