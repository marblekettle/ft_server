<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'where_to_put_mysql_stuff' );

/** MySQL database username */
define( 'DB_USER', 'admin' );

/** MySQL database password */
define( 'DB_PASSWORD', 'moulinette' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/** For the cookie error  */
define('COOKIE_DOMAIN', false);

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'Q[(q%SwW5)0AQKe;HleyvN=XaXkXIJ<n9Yc/[s}uDnXR:Z*yE^ ERV]JM<PeypE0' );
define( 'SECURE_AUTH_KEY',  '~5>,#aA-Hm6cG&&kNwI%)NHOt6`j#MwxD(brVj9:v#*jxsCM#%F]Aq}jb]R[`e4`' );
define( 'LOGGED_IN_KEY',    '#j$QrZa?8+TSnoP=ei6ctR7te@SK=}Y;6e,&u_=cASCOmN,4YQsre4:[][1,VHml' );
define( 'NONCE_KEY',        'Q2J%}tF4?a?,j.<2^>Ql9uf3*[BT,/}j-3zUi&9lApQfHb%3&6@~x6]P!s2f!1qV' );
define( 'AUTH_SALT',        '?8TamCbWa.Hs?pJZn]|($Fi(ivW}94:xkW+e9Qdo!x&tW)sd>k]8;*Xww[SXuC/O' );
define( 'SECURE_AUTH_SALT', ')$<51-N!~!Q.:OJ:5.Ez^eTt>)+rk~Dfnv*L]#~.hnhpw%Ie[=8i>WE5v(3yOfI`' );
define( 'LOGGED_IN_SALT',   '?UpLM2ano9dP0lgzD>cbzgR*&3<^lweLfPT@GoyFrfCo7xtD-s?zx<s91sC,h=/0' );
define( 'NONCE_SALT',       '.t~]R2_DXC]TY%ib !c  - yxZ Pc%%WP8[_ [u+*{5C%D2j,Oc#t~v (x}mnTR*' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
