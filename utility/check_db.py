import optparse
import os
import sys

import mirrormanager2.lib

sys.path.insert(0, os.path.join(os.path.dirname(
    os.path.abspath(__file__)), '..'))


def print_db(session):
    print("version....")
    vers = mirrormanager2.lib.get_versions(session)
    for v in vers:
        print(vars(v))

    print("arch....")
    arches = mirrormanager2.lib.get_arches(session)
    for v in arches:
        print(vars(v))

    print("product....")
    products = mirrormanager2.lib.get_products(session)
    for v in products:
        print(vars(v))

    print("repository....")
    repositories = mirrormanager2.lib.get_repositories(session)
    for v in repositories:
        print(vars(v))

    print("category....")
    categories = mirrormanager2.lib.get_categories(session)
    for v in categories:
        print(vars(v))

    print("directory....")
    directories = mirrormanager2.lib.get_directories(session)
    for v in directories:
        print(vars(v))

    print("category directory....")
    cds = mirrormanager2.lib.get_category_directory(session)
    for v in cds:
        print(vars(v))

    print("file detail....")
    fds = mirrormanager2.lib.get_file_details(session)
    for v in fds:
        print(vars(v))

    print("host category dir....")
    hcds = mirrormanager2.lib.get_host_category_dirs(session)
    for v in hcds:
        print(vars(v))


def main():
    parser = optparse.OptionParser(usage=sys.argv[0] + " [options]")
    parser.add_option(
        "-c", "--config",
        dest="config", default='/etc/mirrormanager/mirrormanager2.cfg',
        help="Configuration file to use")

    (options, args) = parser.parse_args()
    config = dict()
    with open(options.config) as config_file:
        exec(compile(config_file.read(), options.config, 'exec'), config)

    session = mirrormanager2.lib.create_session(config['DB_URL'])

    print("Starting")

    try:
        print_db(session)

    except Exception as ex:
        print("except: ", ex)

    finally:
        session.close()

    print("Ending")

    return 0


if __name__ == "__main__":
    sys.exit(main())
