package NoPaste::Repository::Text;
use strict;
use warnings;
use utf8;

use NoPaste;

my $index = 0;
my $texts = ['this is a sample!'];


sub db { NoPaste->context->db };

sub fetch_by_id {
    my ($class, $id) = @_;

    return $class->db->single(text => {id => $id});
    #my $row = $class->db->single(text => {id => $id});
    #return $row ? $row->text : undef;
}

sub create {
    my ($class, $text) = @_;

    my $id = $class->db->fast_insert(text => {text => $text});
    my $row = $class->db->single(text => {}, {
        columns  => [qw/id/],
        order_by => {id => 'DESC'},
    });
   
    return $row->id;
}

sub update {
    my ($class, $id, $text) = @_;
    $class->db->update(text => {text => $text}, {id => $id});
}

1;
