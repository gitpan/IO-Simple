package IO::Simple;

use 5.000000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use IO::Simple ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
   ios	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
perl M
);

our $VERSION = '0.01';

use Carp;

my $data = {};

sub id {
    my $self = shift;
	return 0+$self;
}
	
sub ios {
	my $file_name = shift;
	my $mode      = shift || 'r';
	my $modes = { 'r' => '<',
				  'w' => '>',
				  'a' => '>>',
				  'read' => '<',
				  'write' => '>',
				  'append' => '>>',
				};
	if (!exists $modes->{$mode}) {
		die "Invalid Mode $mode, should be one of " . join(',', keys %$modes);
	}
	open(my $fh, $modes->{$mode}, $file_name) or croak "Opening '$file_name' for '$mode' failed: $!";
	bless $fh, 'IO::Simple';
	$data->{id($fh)} = {
			file_name => $file_name,
			mode      => $modes->{$mode},
			opened	  => 1,
			@_
	};
	return $fh;
}

sub close {
	my $self = shift;
	my $data = $data->{id($self)};
	close $self or croak "Failed to close '$data->{file_name}' : $!";
	$data->{opened} = 0;
}

sub print {
	my $self = shift;
	my $data = $data->{id($self)};
	croak "File '$data->{file_name}' is not opened." unless $data->{opened};
	croak "File '$data->{file_name}' is not opened for writing." unless $data->{mode} =~ />>|>/;
	print  $self @_;
	return $self;
}

sub say { shift->print(@_, "\n") };

sub slurp {
	my $self = shift;
	my $data = $data->{id($self)};
	croak "File '$data->{file_name}' is not opened." unless $data->{opened};
	croak "File '$data->{file_name}' is not opened for reading." unless $data->{mode} eq '<';
	if (wantarray) {
	   my @lines = <$self>;
	   chomp(@lines) if $data->{autochomp};
	   return @lines;
	} else {
		local $/;
		return <$self>;
	}
}

sub DESTROY {
   my $self = shift;
   delete $data->{id($self)};   
}

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

IO::Simple - Perl extension for blah blah blah

=head1 SYNOPSIS

  use IO::Simple;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for IO::Simple, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

A. U. Thor, E<lt>a.u.thor@a.galaxy.far.far.awayE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by A. U. Thor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
