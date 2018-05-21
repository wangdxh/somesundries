#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include "openssl / bio.h"
#include "openssl / rsa.h"
#include "openssl / crypto.h"
#include "openssl / x509.h"
#include "openssl / pem.h"
#include "openssl / ssl.h"
#include "openssl / err.h"
#define server_cert "./ server.crt"
#define server_key "./ server.key"
#define ca_cert "./ ca.crt"
#define PORT 9876
#define CHK_NULL(x)  \
    if ((x) == NULL) \
    exit(1)
#define CHK_ERR(err, s) \
    if ((err) == -1)    \
    {                   \
        perror(s);      \
        exit(1);        \
    }
#define CHK_SSL(err)                 \
    if ((err) == -1)                 \
    {                                \
        ERR_print_errors_fp(stderr); \
        exit(2);                     \
    }

int main()
{
    int err;
    int listen_sd = -1;
    int sd = -1;
    struct sockaddr_in sa_serv;
    struct sockaddr_in sa_cli;
    int client_len;
    SSL_CTX *ctx = NULL;
    SSL *ssl = NULL;
    X509 *client_cert = NULL;
    char *str = NULL;
    char buf[4096];
    SSL_METHOD *meth = NULL;

    SSL_library_init();
    SSL_load_error_strings();
    ERR_load_BIO_strings();
    OpenSSL_add_all_algorithms();
    meth = (SSL_METHOD *)SSLv23_server_method();
    ctx = SSL_CTX_new(meth);
    if (NULL == ctx)
    {
        goto out;
    }
    //SSL_CTX_set_verify(ctx,SSL_VERIFY_PEER,NULL);
    //SSL_CTX_load_verify_locations(ctx,ca_cert,NULL);
    if (SSL_CTX_use_certificate_file(ctx, server_cert, SSL_FILETYPE_PEM) <= 0)
    {
        goto out;
    }
    if (SSL_CTX_use_PrivateKey_file(ctx, server_key, SSL_FILETYPE_PEM) <= 0)
    {
        goto out;
    }
    if (!SSL_CTX_check_private_key(ctx))
    {
        printf("Private key does not match the certificate public key\n");
        goto out;
    }
    listen_sd = socket(AF_INET, SOCK_STREAM, 0);
    if (-1 == listen_sd)
    {
        goto out;
    }
    memset(&sa_serv, '\0', sizeof(sa_serv));
    sa_serv.sin_family = AF_INET;
    sa_serv.sin_addr.s_addr = INADDR_ANY;
    sa_serv.sin_port = htons(PORT);
    err = bind(listen_sd, (struct sockaddr *)&sa_serv, sizeof(sa_serv));
    if (-1 == err)
    {
        goto out;
    }
    err = listen(listen_sd, 5);
    if (-1 == err)
    {
        goto out;
    }
    client_len = sizeof(sa_cli);
    sd = accept(listen_sd, (struct sockaddr *)&sa_cli, &client_len);
    if (-1 == err)
    {
        goto out;
    }
    printf("Connection from % d, port % d\n", sa_cli.sin_addr.s_addr, sa_cli.sin_port);
    ssl = SSL_new(ctx);
    if (NULL == ssl)
    {
        goto out;
    }
    SSL_set_fd(ssl, sd);
    err = SSL_accept(ssl);
    if (NULL == ssl)
    {
        goto out;
    }
    /*
printf ("SSL connection using %s\n", SSL_get_cipher(ssl));
client_cert = SSL_get_peer_certificate(ssl);
if (client_cert != NULL) {
printf ("Client certificate:\n");
str = X509_NAME_oneline (X509_get_subject_name (client_cert), 0, 0);
CHK_NULL(str);
printf ("\t subject: %s\n", str);
Free (str);
str = X509_NAME_oneline (X509_get_issuer_name (client_cert), 0, 0);
CHK_NULL(str);
printf ("\t issuer: %s\n", str);
Free (str);
X509_free (client_cert);
}
else
printf ("Client does not have certificate.\n");
*/
    err = SSL_read(ssl, buf, sizeof(buf) – 1);
    if (err == -1)
    {
        goto out;
    }
    buf[err] = '\0';
    printf("Got % d chars
           :'% s'\n", err, buf);
    err = SSL_write(ssl, "I hear you.", strlen("I hear you."));
    CHK_SSL(err);

out:
    if (-1 != sd)
    {
        close(sd);
    }
    if (-1 != listen_sd)
    {
        close(listen_sd);
    }

    if (ssl)
    {
        SSL_free(ssl);
    }
    if (ctx)
    {
        SSL_CTX_free(ctx);
    }
    return 0;
}