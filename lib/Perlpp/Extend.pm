package Perlpp::Extend;

use 5.008;
use strict;
use warnings FATAL => 'all';

our $VERSION = 0.002;

use DynaLoader;
use Config;
use Carp qw/croak/;
use Scalar::Util qw/tainted/;

sub to_filename {
	my $module = shift;
	$module =~ s{ :: | ' }{/}gx;
	$module .= ".$Config{dlext}";
	return $module;
}

sub import {
	my $package  = shift;
	my $module   = shift || caller;
	my $file_rel = shift || to_filename($module);

	load_module($module, $file_rel);
	return;
}

sub load_module {
	my ($module, $file_rel) = @_;

	croak "Can't load tainted filename '$file_rel'" if tainted($file_rel);

	my $file = DynaLoader->dl_findfile($file_rel) or croak "Can't find '$file_rel': " . DynaLoader::dl_error;

	local @DynaLoader::dl_require_symbols = qw/perlpp_exporter/;
	my $handle = DynaLoader::dl_load_file($file, 0) or croak "Can't load '$file': " . DynaLoader::dl_error;
	push @DynaLoader::dl_librefs, $handle;    # record loaded object

	if (my @unresolved = DynaLoader::dl_undef_symbols()) {
		croak "Unresolved symbols after loading $file: @unresolved";
	}

	my $perlpp_exporter = DynaLoader::dl_find_symbol($handle, 'perlpp_exporter') or croak "Can't find exporter in '$file': " . DynaLoader::dl_error;
	my $sub = DynaLoader::dl_install_xsub('', $perlpp_exporter, $file) or croak "Can't install_xsub on '$file': " . DynaLoader::dl_error;

	push @DynaLoader::dl_shared_objects, $file;      # record files loaded
	push @DynaLoader::dl_modules,        $module;    # record loaded module

	return $sub->($module) or croak "Something went horribly wrong during loading of $module";
}

1;

__END__

=head1 NAME

Perlpp::Extend - Dynamically load C++ module into your perl program.

=head1 VERSION

Version 0.002

=head1 SYNOPSIS

 use Perlpp::Extend;

=head1 DESCRIPTION

This module loads the C++ part of your libperl++ library. In normal usage, it's used like this:

 use Perlpp::Extend;

It can take two arguments. The first is the name of the module the libary should be exported to (defaults to the calling package), the second is then name of the library file (C<to_filename($module)>).

=head1 FUNCTIONS

This module defines two functions. Under normal circumstances, you shouldn't need to call them directly but simply C<use> this module.

=over 4

=item * to_filename($module_name)

Converts a module name to a filename of the dynamically loadable library.

=item * load_module($module, $filename)

This loads $filename into $module.

=back

=head1 DIAGNOSTICS

Perlpp::Extend will try to give helpful diagnostics when module loading fails, but usually it's at the mercy of your OS's libraries in doing so.

=head1 DEPENDENCIES

This module depends on perl 5.8.

=head1 BUGS AND LIMITATIONS

This module is experimental. Bugs are likely to exist.

=head1 SEE ALSO

=over 4

=item * libperl++

=item * L<DynaLoader>

=back

=head1 AUTHOR

Leon Timmermans, C<< <leont at cpan.org> >>

=head1 SUPPORT

Bugs can be filed or found at http://github.com/Leont/libperl--/issues. 

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Leon Timmermans, all rights reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as perl itself.
