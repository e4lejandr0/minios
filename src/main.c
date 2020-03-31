/* Author: akdev <alex@akdev.xyz>
 * minios entrypoint
 */
int kmain() {
    asm(
        "hlt"
    :
    : );
    return 0;
}
