package Daje::Plugin::GeneratePerl;
use Mojo::Base 'Daje::Plugin::Base::Perl::Common', base, -signatures;

use Mojo::JSON qw{from_json};
use Mojo::File;
use Daje::Plugin::Perl::Manager;

# NAME
# ====
#
# Daje::Plugin::GeneratePerl - It's new $module
#
# SYNOPSIS
#
#    use Daje::Plugin::GeneratePerl;
#
# DESCRIPTION
# ===========
#
# Daje::Plugin::GeneratePerl is ...
#
# LICENSE
# =======
# 
# Copyright (C) janeskil1525.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# AUTHOR
#
# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>
#

our $VERSION = '0.03';

sub process($self) {
    $self->_load_config();
    my $json = $self->_get_json();
    $self->_create_perl($json);
}

sub _create_perl($self, $json) {
    my $template = $self->_load_templates(
        'Daje::Generate::Templates::Perl',
        "class,method,baseclass,interface,load_from_pkey,load_from_fkey,load_list,insert_data,update_data,fields_method"
    );

    my $manager = Daje::Plugin::Perl::Manager->new(
        config      => $self->config(),
        template    => $template,
        json        => $json,
    )->generate_classes();

    return $manager->success()
}

sub _get_json($self) {
    my $path = $self->config->{PATH}->{schema_dir};
    my $json_txt = Mojo::File->new($path . "schema.json")->slurp();
    my $json = from_json($json_txt);

    return $json;
}





1;
__END__


#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME


Daje::Plugin::GeneratePerl - It's new $module

SYNOPSIS

   use Daje::Plugin::GeneratePerl;



=head1 DESCRIPTION


Daje::Plugin::GeneratePerl is ...



=head1 REQUIRES

L<Daje::Plugin::Perl::Manager> 

L<Mojo::File> 

L<Mojo::JSON> 

L<Mojo::Base> 


=head1 METHODS

=head2 process($self)

 process($self)();


=head1 LICENSE


Copyright (C) janeskil1525.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

AUTHOR

janeskil1525 E<lt>janeskil1525@gmail.comE<gt>



=cut

