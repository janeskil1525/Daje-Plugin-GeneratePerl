package Daje::Plugin::Perl::Manager;
use Mojo::Base 'Daje::Plugin::Perl::Base::Common';

use Daje::Generate::Perl::Generate::Fields;
use Daje::Generate::Perl::Generate::Methods;
use Daje::Generate::Perl::Generate::Class;
use Daje::Generate::Output::Perl::Class;
use Daje::Generate::Perl::Generate::BaseClass;
use Daje::Generate::Perl::Generate::Interface;

field $success :reader = 1;
field $config :param :reader;

method generate_classes() {
    $self->_base_class();
    my $length = scalar @{$self->json->{tables}};
    for (my $i = 0; $i < $length; $i++) {
        $self->_generate_table_class(@{$self->json->{tables}}[$i]);
        $self->_generate_interface_class(@{$self->json->{tables}}[$i]->{table}->{table_name});
    }
    $length = scalar $self->json->{views};
    for (my $i = 0; $i < $length; $i++) {
        $self->_generate_view_class(@{$self->json->{views}}[$i]);
    }
    return 1;
}

method _generate_interface_class($table_name) {
    my $template = $self->template();
    Daje::Generate::Perl::Generate::Interface->new(
        template => $template,
        config   => $config,
        table    => $table_name,
    )->generate();
}

method _base_class() {
    my $template = $self->template();
    Daje::Generate::Perl::Generate::BaseClass->new(
        template => $template,
        config   => $config,
    )->generate();

}

method _generate_table_class($table) {
    my $fields = $self->_get_fields($table);
    my $methods = $self->_methods($fields, $table);
    my $perl = $self->_class($methods, $table, $fields);
    $self->_save_class($perl, $table->{table});
}

method _save_class($perl, $table) {

    my $output = Daje::Generate::Output::Perl::Class->new(
        config         => $config,
        table_name     => $table->{table_name},
        perl           => $perl,
        name_space_dir => "name_space_dir",
    );
    $output->save_file();
}

method _class($methods, $table, $fields) {
    my $template = $self->template();
    my $class = Daje::Generate::Perl::Generate::Class->new(
        json     => $table->{table},
        methods  => $methods,
        template => $template,
        config   => $config,
        fields   => $fields,
    );
    my $perl = $class->generate();

    return $perl;
}

method _methods($fields, $table) {
    my $template = $self->template();
    my $methods = Daje::Generate::Perl::Generate::Methods->new(
        json     => $table->{table},
        fields   => $fields,
        template => $template
    );
    $methods->generate();

    return $methods;
}

method _generate_view_class($view) {
    $view = $view;
}

method _get_fields($json) {
    my $template = $self->template();
    my $fields = Daje::Generate::Perl::Generate::Fields->new(
        json     => $json->{table},
        template => $template
    );
    $fields->generate();
    return $fields;
}

1;