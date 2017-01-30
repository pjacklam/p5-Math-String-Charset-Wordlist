#!/usr/bin/perl -w

# for Math::String::Charset::Wordlist.pm

use Test;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../lib'; # to run manually
  unshift @INC, '../blib/arch';
  chdir 't' if -d 't';
  plan tests => 81;
  }

use Math::String::Charset::Wordlist;
use Math::String;

$Math::String::Charset::die_on_error = 0;	# we better catch them
my $a;

my $c = 'Math::String::Charset::Wordlist';

###############################################################################
# creating via Math::String::Charset

$a = Math::String::Charset->new( { type => 2, order => 1,
  file => 'testlist.lst' } );
ok ($a->error(),"");
ok (ref($a),$c);
ok ($a->isa('Math::String::Charset'));
ok ($a->file(),'testlist.lst');

# create directly
$a = $c->new( { file => 'testlist.lst' } );
ok ($a->error(),"");
ok (ref($a),$c);
ok ($a->isa('Math::String::Charset'));
ok ($a->file(),'testlist.lst');

###############################################################################
# dictionary tests

#1:dictionary
#2:math
#3:string
#4:test
#5:unsorted
#6:wordlist

ok ($a->first(1), 'dictionary');
ok ($a->num2str(0), '');
ok ($a->num2str(1),'dictionary');
ok ($a->num2str(2),'math');
ok ($a->num2str(3),'string');
ok ($a->num2str(4),'test');
ok ($a->num2str(5),'unsorted');
ok ($a->num2str(6),'wordlist');

ok ($a->char(0),'dictionary');
ok ($a->char(-1),'wordlist');
ok ($a->char(1),'math');
ok ($a->char(-2),'unsorted');

ok (join(":",$a->start()),'dictionary:math:string:test:unsorted:wordlist');
ok (join(":",$a->end()),'dictionary:math:string:test:unsorted:wordlist');
ok (join(":",$a->ones()),'dictionary:math:string:test:unsorted:wordlist');
ok (scalar $a->start(), 6);
ok (scalar $a->end(), 6);
ok (scalar $a->ones(), 6);

# num2str in list mode
my @a = $a->num2str(1);
ok ($a[0],'dictionary');
ok ($a[1],1);		# one word is one "character"


ok ($a->length(),6);
ok ($a->count(1),6);

ok ($a->str2num('dictionary'),1);
ok ($a->str2num('math'),2);
ok ($a->str2num('string'),3);
ok ($a->str2num('test'),4);
ok ($a->str2num('unsorted'),5);
ok ($a->str2num('wordlist'),6);

#########################
# test offset()

ok ($a->offset(0),0);
ok ($a->offset(1),11);
ok ($a->offset(2),16);

# test caching and next()/prev()

my $x = Math::String->new('unsorted',$a);
$x++;
ok ($x - Math::BigInt->new(6), '');
ok ($x,'wordlist');
$x--;
ok ($x - Math::BigInt->new(5), '');
ok ($x,'unsorted');

###############################################################################
# creating via Math::String::Charset w/ scale

$a = Math::String::Charset->new( { type => 2, order => 1,
  file => 'testlist.lst', scale => 2, } );
ok ($a->error(),"");
ok (ref($a),$c);
ok ($a->isa('Math::String::Charset'));
ok ($a->isa('Math::String::Charset::Wordlist'));

###############################################################################
# copy()

my $b = $a->copy();

ok ($b->error(),"");
ok (ref($b),$c);
ok ($b->isa('Math::String::Charset'));
ok ($b->isa('Math::String::Charset::Wordlist'));
ok ($b->file(),'testlist.lst');

# check that the tied object is not copied
print "different\n" if ref($b->{list}) != ref($a->{list});
print "different\n" if ref(tied $b->{list}) != ref( tied $a->{list});

ok ($b->{_obj} eq $a->{_obj}, 1 );

# see if copy and original still work
for my $cs ($a,$b)
  {
  ok ($cs->first(1), 'dictionary');
  ok ($cs->num2str(0), '');
  ok ($cs->num2str(1),'dictionary');
  ok ($cs->num2str(2),'math');
  ok ($cs->num2str(3),'string');
  ok ($cs->num2str(4),'test');
  ok ($cs->num2str(5),'unsorted');
  ok ($cs->num2str(6),'wordlist');

  ok ($cs->str2num('dictionary'),1);
  ok ($cs->str2num('math'),2);
  ok ($cs->str2num('string'),3);
  ok ($cs->str2num('test'),4);
  ok ($cs->str2num('unsorted'),5);
  ok ($cs->str2num('wordlist'),6);

  }

###############################################################################
# Perl 5.005 does not like ok ($x,undef)

sub ok_undef
  {
  my $x = shift;

  ok (1,1) and return if !defined $x;
  ok ($x,'undef');
  }


