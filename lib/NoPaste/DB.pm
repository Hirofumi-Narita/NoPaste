package NoPaste::DB;
use strict;
use warnings;
use utf8;
use parent qw(Teng);
use Time::Moment;
use Class::Method::Modifiers;

__PACKAGE__->load_plugin('Count');
__PACKAGE__->load_plugin('Replace');
__PACKAGE__->load_plugin('Pager');

before do_insert => sub {
    my ($self, $table_name, $row_data) = @_;
    $row_data->{created_at} //= Time::Moment->now;
};


1;
