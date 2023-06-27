workspace {
    model {
        # People/Actors
        # <variable> = person <name> <description> <tag>
        publicUser = person "Public User" "An anonymous user of the bookstore" "User"
        authorizedUser = person "Authorized User" "A registered user of the bookstore, with personal account" "User"

        # Software Systems
        # <variable> = softwareSystem <name> <description> <tag>
        bookstoreSystem = softwareSystem "iBookstore System" "Allows users to view about book, and administrate the book details" "Target System" {
            # Level 2: Containers
            # <variable> = container <name> <description> <technology> <tag>
            searchWebApi = container "Search Web API" "Allows only authorized users searching books records via HTTPS API" "Go"
            adminWebApi = container "Admin Web API" "Allows only authorized users administering books details via HTTPS API" "Go" {
                # Level 3: Components
                # <variable> = component <name> <description> <technology> <tag>
                bookService = component "Book Service" "Allows administrating book details" "Go"
                authService = component "Authorizer" "Authorize users by using external Authorization System" "Go"
                bookEventPublisher = component "Book Events Publisher" "Publishes books-related events to Events Publisher" "Go"
            }
            publicWebApi = container "Public Web API" "Allows public users getting books information" "Go"
            searchDatabase = container "Search Database" "Stores searchable book information" "ElasticSearch" "Database"
            bookstoreDatabase = container "Bookstore Database" "Stores book details" "PostgreSQL" "Database"
            bookEventStream = container "Book Event Stream" "Handles book-related domain events" "Apache Kafka 3.0"
            bookSearchEventConsumer = container "Book Search Event Consumer" "Listening to domain events and write publisher to Search Database for updating" "Go"
            publisherRecurrentUpdater = container "Publisher Recurrent Updater" "Listening to external events from Publisher System, and update book information" "Go"
        }
        
        # External Software Systems
        authSystem = softwareSystem "Authorization System" "The external Identiy Provider Platform" "External System"
        publisherSystem = softwareSystem "Publisher System" "The 3rd party system of publishers that gives details about books published by them" "External System"
        
        # Relationship between People and Software Systems
        # <variable> -> <variable> <description> <protocol>
        publicUser -> bookstoreSystem "View book information"
        authorizedUser -> bookstoreSystem "Search book with more details, administrate books and their details"
        bookstoreSystem -> authSystem "Register new user, and authorize user access"
        publisherSystem -> bookstoreSystem "Publish events for new book publication, and book information updates" {
            tags "Async Request"
        }

        # Relationship between Containers
        publicUser -> publicWebApi "View book information" "JSON/HTTPS"
        publicWebApi -> searchDatabase "Retrieve book searchable information" "ODBC"
        authorizedUser -> searchWebApi "Search book with more details" "JSON/HTTPS"
        searchWebApi -> authSystem "Authorize user" "JSON/HTTPS"
        searchWebApi -> searchDatabase "Retrieve searchable book information" "ODBC"
        authorizedUser -> adminWebApi "Administrate books and their details" "JSON/HTTPS"
        adminWebApi -> authSystem "Authorize user" "JSON/HTTPS"
        adminWebApi -> bookstoreDatabase "Reads/Write book detail data" "ODBC"
        adminWebApi -> bookEventStream "Publish book update events" {
            tags "Async Request"
        }
        bookEventStream -> bookSearchEventConsumer "Consume book update events"
        bookSearchEventConsumer -> searchDatabase "Write book searchable information" "ODBC"
        publisherRecurrentUpdater -> adminWebApi "Makes API calls to" "JSON/HTTPS"

        # Relationship between Containers and External System
        publisherSystem -> publisherRecurrentUpdater "Consume book publication update events" {
            tags "Async Request"
        }

        # Relationship between Components
        authorizedUser -> bookService "Administrate book details" "JSON/HTTPS"
        publisherRecurrentUpdater -> bookService "Makes API calls to" "JSON/HTTPS"
        bookService -> authService "Uses"
        bookService -> bookEventPublisher "Uses"

        # Relationship between Components and Other Containers
        authService -> authSystem "Authorize user permissions" "JSON/HTTPS"
        bookService -> bookstoreDatabase "Read/Write data" "ODBC"
        bookService -> bookstoreDatabase "Read/Write data" "ODBC"
        bookEventPublisher -> bookEventStream "Publish book update events"
        
        # # Deployment for Dev Env
        # deploymentEnvironment "Development" {
        #     deploymentNode "Developer Laptop" "" "Microsoft Windows 10 or Apple macOS" {
        #         deploymentNode "Web Browser" "" "Chrome, Firefox, Safari, or Edge" {
        #             containerInstance singlePageApp
        #         }
        #         deploymentNode "Docker Container - Web Server" "" "Docker" {
        #             deploymentNode "Apache Tomcat" "" "Apache Tomcat 8.x" {
        #                 containerInstance webApp
        #                 containerInstance apiApp
        #             }
        #         }
        #         deploymentNode "Docker Container - Database Server" "" "Docker" {
        #             deploymentNode "Database Server" "" "Oracle 12c" {
        #                 containerInstance database
        #             }
        #         }
        #     }
        # }
    }

    views {
        # Level 1
        systemContext bookstoreSystem "SystemContext" {
            include *
            # default: tb,
            # support tb, bt, lr, rl
            autoLayout
        }
        # Level 2
        container bookstoreSystem "Containers" {
            include *
            autoLayout lr
        }
        # Level 3
        component adminWebApi "Components" {
            include *
            autoLayout
        }
        # deployment <software-system> <environment> <key> <description>
        # deployment iBankingSys "Development" "Dep-002-DEV" "Environment for Developer" {
        #     include *           
        #     autoLayout
        # }
        # dynamic apiApp "SignIn" "Summarises how the sign in feature works in the single-page application." {
        #     singlePageApp -> signinController "Submits credentials to"
        #     signinController -> securityComponent "Validates credentials using"
        #     securityComponent -> database "select * from users where username = ?"
        #     database -> securityComponent "Returns user data to"
        #     securityComponent -> signinController "Returns true if the hashed password matches"
        #     signinController -> singlePageApp "Sends back an authentication token to"
        #     autoLayout
        # }

        styles {
            # element <tag> {}
            element "Customer" {
                background #08427B
                color #ffffff
                fontSize 22
                shape Person
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            relationship "Relationship" {
                dashed false
            }
            relationship "Async Request" {
                dashed true
            }
            element "Database" {
                shape Cylinder
            }
        }

        theme default
    }

}