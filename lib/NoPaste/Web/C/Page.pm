package NoPaste::Web::C::Page;
use NoPaste::Repository::Text;
use NoPaste::Web;
use NoPaste::DB::Row::Text;

use DDP;

sub get_root {
    my ($class, $c, $args) = @_;
 
    return $c->render('form.tx', {
        action => '/',
        button => 'create',
    });
}

sub get_id {
    my ($class, $c, $args) = @_;
    my $id = $args->{id};

    my $row = NoPaste::Repository::Text->fetch_by_id($id)
        or return $c->res_404;

    $c->fillin_form({text => $row->text});
    return $c->render('form.tx', {
        action => "/$id",
        button => 'update',
        created_at => $row->created_at_str,
        updated_at => $row->updated_at_str,
    });
}

sub post_root {
    my ($class, $c, $args) = @_;

    my $text = $c->req->parameters->{text}
        or return $c->res_400;

    my $id = NoPaste::Repository::Text->create($text);

    return $c->redirect("/$id");
}

sub post_id {
    my ($class, $c, $args) = @_;
    my $id = $args->{id};

    my $text = $c->req->parameters->{text} or return $c->res_400;
    my $old_text = NoPaste::Repository::Text->fetch_by_id($id) or return $c->res_404;

    NoPaste::Repository::Text->update($id, $text);

    return $c->redirect("/$id");
}

1;
